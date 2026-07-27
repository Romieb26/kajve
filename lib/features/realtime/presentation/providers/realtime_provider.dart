//libs/features/realtime/presentation/providers/realtime_provider.dart
import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../../monitoring/domain/entities/estadisticas_entity.dart';
import '../../../monitoring/domain/usecases/get_estadisticas_usecase.dart';
import '../../data/datasources/realtime_ws_datasource.dart';
import '../../domain/entities/lectura_tiempo_real_entity.dart';

part 'realtime_provider.g.dart';

class RealtimeState {
  final bool isLoading;
  final String? errorMessage;

  final EstadisticasEntity? estadisticas;

  /// Serie de lecturas en vivo que llega por el WebSocket de ws-gateway:
  /// el primer mensaje ("historial") la puebla de golpe, y cada evento
  /// ("osil.data.updated") le agrega un punto nuevo. Acotada a los
  /// últimos [RealtimeController._maxPuntos] para no crecer sin límite
  /// mientras la pantalla esté abierta.
  final List<LecturaTiempoRealEntity> serieTiempoReal;

  /// true mientras el WebSocket esté conectado y recibiendo datos; false
  /// si aún no conecta o se cayó. El histórico y las estadísticas siguen
  /// funcionando aunque esto sea false (ws-gateway sirve el histórico aun
  /// sin Redis disponible).
  final bool wsConectado;

  const RealtimeState({
    this.isLoading = false,
    this.errorMessage,
    this.estadisticas,
    this.serieTiempoReal = const [],
    this.wsConectado = false,
  });

  RealtimeState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
    EstadisticasEntity? estadisticas,
    bool clearEstadisticas = false,
    List<LecturaTiempoRealEntity>? serieTiempoReal,
    bool? wsConectado,
  }) {
    return RealtimeState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      estadisticas:
          clearEstadisticas ? null : (estadisticas ?? this.estadisticas),
      serieTiempoReal: serieTiempoReal ?? this.serieTiempoReal,
      wsConectado: wsConectado ?? this.wsConectado,
    );
  }
}

@riverpod
class RealtimeController extends _$RealtimeController {
  static const int _maxPuntos = 60;

  /// Cuánto esperar antes de reintentar el WebSocket cuando se cae solo
  /// (ej. close 1005 por una red inestable o un timeout del gateway).
  static const Duration _reintentoWs = Duration(seconds: 5);

  int? _loteIdActual;
  StreamSubscription<RealtimeWsMessage>? _wsSubscription;
  Timer? _refrescoEstadisticasTimer;
  Timer? _reconexionWsTimer;

  final RealtimeWsDataSource _wsDataSource = getIt<RealtimeWsDataSource>();
  final SecureStorage _secureStorage = getIt<SecureStorage>();

  @override
  RealtimeState build() {
    ref.onDispose(detenerTiempoReal);
    return const RealtimeState();
  }

  Future<void> cargarEstadisticas(int loteId) async {
    if (loteId != _loteIdActual) {
      state = state.copyWith(clearEstadisticas: true);
    }

    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final estadisticas = await getIt<GetEstadisticasUseCase>()(loteId);
      state = state.copyWith(estadisticas: estadisticas);
    } catch (_) {
      // Silencioso a propósito, igual que la pantalla de Sensores: si
      // /estadisticas falla (ej. api-mobile caído o con una consulta
      // rota), Tiempo Real no depende de este dato para lo importante
      // (las gráficas/valores en vivo vienen del WebSocket aparte), así
      // que no tiene caso interrumpir al usuario con un error por algo
      // que se sigue reintentando solo cada 5s (ver
      // _refrescoEstadisticasTimer). Si el backend se arregla, el
      // encabezado se llena solo en el siguiente refresco sin que el
      // usuario tenga que hacer nada.
      state = state.copyWith(clearEstadisticas: true);
    } finally {
      _loteIdActual = loteId;
      state = state.copyWith(isLoading: false);
    }
  }

  /// Arranca el monitoreo en tiempo real de un lote: carga las
  /// estadísticas agregadas por REST (una vez, y luego cada 5s para
  /// refrescarlas, al mismo ritmo que manda datos el ESP32 — como esto ya
  /// no muestra error si falla, reintentar seguido es barato y hace que
  /// se "autocure" apenas el backend responda bien de nuevo), y abre el
  /// WebSocket de ws-gateway para recibir el histórico y las lecturas en
  /// vivo de todas las variables del sensor.
  Future<void> iniciarTiempoReal(int loteId) async {
    detenerTiempoReal();

    await cargarEstadisticas(loteId);
    _refrescoEstadisticasTimer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => cargarEstadisticas(loteId),
    );

    final token = await _secureStorage.getAccessToken();
    if (token == null) {
      state = state.copyWith(
        errorMessage: "Tu sesión expiró. Inicia sesión de nuevo.",
      );
      return;
    }

    state = state.copyWith(serieTiempoReal: []);

    _suscribirWs(loteId, token);
  }

  void _suscribirWs(int loteId, String token) {
    _wsSubscription = _wsDataSource.connect(loteId, token).listen(
      (mensaje) {
        List<LecturaTiempoRealEntity> serie = state.serieTiempoReal;
        if (mensaje.esHistorial) {
          serie = mensaje.historial;
        } else if (mensaje.lectura != null) {
          serie = [...serie, mensaje.lectura!];
          if (serie.length > _maxPuntos) {
            serie = serie.sublist(serie.length - _maxPuntos);
          }
        }
        state = state.copyWith(serieTiempoReal: serie, wsConectado: true);
      },
      onError: (_) {
        state = state.copyWith(wsConectado: false);
        _programarReconexionWs(loteId);
      },
      onDone: () {
        state = state.copyWith(wsConectado: false);
        _programarReconexionWs(loteId);
      },
    );
  }

  /// El WebSocket de ws-gateway se puede caer solo (red del celular,
  /// timeout del gateway, etc.) sin que el usuario haga nada. Antes, una
  /// vez caído, la pantalla se quedaba en "Conectando..." para siempre —
  /// solo se recuperaba si el usuario hacía pull-to-refresh o mandaba la
  /// app a segundo plano y la regresaba. Esto reintenta solo, como ya
  /// hacía _refrescoEstadisticasTimer con /estadisticas.
  void _programarReconexionWs(int loteId) {
    _reconexionWsTimer?.cancel();
    _reconexionWsTimer = Timer(_reintentoWs, () async {
      // Si mientras tanto se cambió de lote o se salió de la pantalla
      // (detenerTiempoReal limpia _loteIdActual), no reconectamos.
      if (_loteIdActual != loteId) return;

      // CRÍTICO: todo el intento va en try/catch. Antes, si algo tronaba
      // aquí (token nulo, excepción de red, lo que sea), el ciclo de
      // reintentos moría para siempre — nada volvía a llamar
      // _programarReconexionWs — y la pantalla se quedaba "Conectando..."
      // de forma indefinida sin que el usuario supiera por qué (el bug
      // real detrás de "dejó de conectar y no volvió").
      try {
        final token = await _secureStorage.getAccessToken();
        if (token == null) {
          state = state.copyWith(
            errorMessage: "Tu sesión expiró. Inicia sesión de nuevo.",
          );
          return;
        }

        _wsDataSource.disconnect();
        _suscribirWs(loteId, token);
      } catch (_) {
        _programarReconexionWs(loteId);
      }
    });
  }

  void detenerTiempoReal() {
    _refrescoEstadisticasTimer?.cancel();
    _refrescoEstadisticasTimer = null;

    _reconexionWsTimer?.cancel();
    _reconexionWsTimer = null;

    _loteIdActual = null;

    _wsSubscription?.cancel();
    _wsSubscription = null;
    _wsDataSource.disconnect();
    state = state.copyWith(wsConectado: false);
  }
}
