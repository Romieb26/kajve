//libs/features/realtime/presentation/providers/realtime_provider.dart
import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../../monitoring/data/datasources/monitoring_remote_datasource.dart';
import '../../../monitoring/data/repositories/monitoring_repository_impl.dart';
import '../../../monitoring/domain/entities/estadisticas_entity.dart';
import '../../../monitoring/domain/usecases/get_estadisticas_usecase.dart';
import '../../data/datasources/realtime_ws_datasource.dart';
import '../../domain/entities/lectura_tiempo_real_entity.dart';

class RealtimeProvider extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;

  EstadisticasEntity? estadisticas;

  /// Serie de lecturas en vivo que llega por el WebSocket de ws-gateway:
  /// el primer mensaje ("historial") la puebla de golpe, y cada evento
  /// ("osil.data.updated") le agrega un punto nuevo. Acotada a los
  /// últimos [_maxPuntos] para no crecer sin límite mientras la pantalla
  /// esté abierta.
  List<LecturaTiempoRealEntity> serieTiempoReal = [];

  /// true mientras el WebSocket esté conectado y recibiendo datos; false
  /// si aún no conecta o se cayó. El histórico y las estadísticas siguen
  /// funcionando aunque esto sea false (ws-gateway sirve el histórico aun
  /// sin Redis disponible).
  bool wsConectado = false;

  static const int _maxPuntos = 60;

  /// Cuánto esperar antes de reintentar el WebSocket cuando se cae solo
  /// (ej. close 1005 por una red inestable o un timeout del gateway).
  static const Duration _reintentoWs = Duration(seconds: 5);

  int? _loteIdActual;
  StreamSubscription<RealtimeWsMessage>? _wsSubscription;
  Timer? _refrescoEstadisticasTimer;
  Timer? _reconexionWsTimer;

  final RealtimeWsDataSource _wsDataSource = RealtimeWsDataSource();
  final SecureStorage _secureStorage = SecureStorage();

  late final MonitoringRepositoryImpl _repository = MonitoringRepositoryImpl(
    MonitoringRemoteDataSourceImpl(ApiClient(), _secureStorage),
  );

  late final GetEstadisticasUseCase _getEstadisticasUseCase =
      GetEstadisticasUseCase(_repository);

  Future<void> cargarEstadisticas(int loteId) async {
    if (loteId != _loteIdActual) {
      estadisticas = null;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      estadisticas = await _getEstadisticasUseCase(loteId);
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
      estadisticas = null;
    } finally {
      _loteIdActual = loteId;
      isLoading = false;
      notifyListeners();
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
      errorMessage = "Tu sesión expiró. Inicia sesión de nuevo.";
      notifyListeners();
      return;
    }

    serieTiempoReal = [];

    _suscribirWs(loteId, token);
  }

  void _suscribirWs(int loteId, String token) {
    _wsSubscription = _wsDataSource.connect(loteId, token).listen(
      (mensaje) {
        if (mensaje.esHistorial) {
          serieTiempoReal = mensaje.historial;
        } else if (mensaje.lectura != null) {
          serieTiempoReal = [...serieTiempoReal, mensaje.lectura!];
          if (serieTiempoReal.length > _maxPuntos) {
            serieTiempoReal =
                serieTiempoReal.sublist(serieTiempoReal.length - _maxPuntos);
          }
        }
        wsConectado = true;
        notifyListeners();
      },
      onError: (_) {
        wsConectado = false;
        notifyListeners();
        _programarReconexionWs(loteId);
      },
      onDone: () {
        wsConectado = false;
        notifyListeners();
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
          errorMessage = "Tu sesión expiró. Inicia sesión de nuevo.";
          notifyListeners();
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
    wsConectado = false;
  }

  @override
  void dispose() {
    detenerTiempoReal();
    super.dispose();
  }
}
