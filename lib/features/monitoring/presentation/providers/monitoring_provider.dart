//lib/features/monitoring/presentation/providers/monitoring_provider.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/estadisticas_entity.dart';
import '../../domain/entities/lectura_entity.dart';
import '../../domain/entities/resumen_lote_entity.dart';
import '../../domain/usecases/get_estadisticas_usecase.dart';
import '../../domain/usecases/get_lecturas_usecase.dart';
import '../../domain/usecases/get_resumen_lote_usecase.dart';

part 'monitoring_provider.g.dart';

class MonitoringState {
  final bool isLoading;
  final String? errorMessage;

  final List<LecturaEntity> lecturas;
  final EstadisticasEntity? estadisticas;

  /// Resumen del lote completo (min/prom/max de TODAS las lecturas),
  /// calculado en ws-gateway — no depende de api-mobile, así que no se ve
  /// afectado por el error 500 de /lotes/{id}/estadisticas.
  final ResumenLoteEntity? resumen;

  const MonitoringState({
    this.isLoading = false,
    this.errorMessage,
    this.lecturas = const [],
    this.estadisticas,
    this.resumen,
  });

  MonitoringState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
    List<LecturaEntity>? lecturas,
    EstadisticasEntity? estadisticas,
    bool clearEstadisticas = false,
    ResumenLoteEntity? resumen,
    bool clearResumen = false,
  }) {
    return MonitoringState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      lecturas: lecturas ?? this.lecturas,
      estadisticas:
          clearEstadisticas ? null : (estadisticas ?? this.estadisticas),
      resumen: clearResumen ? null : (resumen ?? this.resumen),
    );
  }
}

@riverpod
class MonitoringController extends _$MonitoringController {
  int? _loteIdActual;

  @override
  MonitoringState build() => const MonitoringState();

  Future<void> cargarDatos(int loteId) async {
    // Si es un lote distinto al que ya estaba cargado, se limpian los
    // datos antes de esperar la respuesta: si la petición falla, la UI
    // nunca debe seguir mostrando datos de un lote distinto al que el
    // usuario está viendo. Si es el mismo lote (ej. un tick del
    // auto-refresh), se dejan los datos anteriores visibles mientras se
    // espera, para no parpadear a un estado vacío en cada refresco.
    if (loteId != _loteIdActual) {
      state = state.copyWith(lecturas: [], clearEstadisticas: true);
    }

    state = state.copyWith(isLoading: true, clearError: true);

    // Se piden por separado (no con Future.wait) para que un fallo en
    // /lecturas no tumbe también /estadisticas: antes, si cualquiera de
    // las dos fallaba, la pantalla completa se quedaba en "no se pudo
    // conectar" aunque la otra sí hubiera respondido bien. Las
    // estadísticas son lo importante de esta pantalla; las lecturas solo
    // se usan para saber si mostrar el aviso de "sin lecturas".
    EstadisticasEntity? estadisticasNuevas;
    String? errorEstadisticas;
    try {
      estadisticasNuevas = await getIt<GetEstadisticasUseCase>()(loteId);
    } on ApiException catch (e) {
      errorEstadisticas = mensajeAmigable(e);
    } catch (_) {
      errorEstadisticas = "Ocurrió un error al cargar el monitoreo.";
    }

    List<LecturaEntity> lecturasNuevas;
    try {
      lecturasNuevas = await getIt<GetLecturasUseCase>()(loteId);
    } catch (_) {
      // No es crítico: si falla, simplemente se asume "sin lecturas" en
      // vez de tumbar toda la pantalla.
      lecturasNuevas = [];
    }

    // El resumen viene de ws-gateway (Postgres directo), no de api-mobile:
    // se pide siempre, incluso si /estadisticas falló arriba, porque no
    // comparten backend ni pueden fallar por la misma causa.
    ResumenLoteEntity? resumenNuevo;
    try {
      resumenNuevo = await getIt<GetResumenLoteUseCase>()(loteId);
    } catch (_) {
      resumenNuevo = null;
    }

    _loteIdActual = loteId;
    state = state.copyWith(
      isLoading: false,
      lecturas: lecturasNuevas,
      estadisticas: estadisticasNuevas,
      clearEstadisticas: estadisticasNuevas == null,
      errorMessage: estadisticasNuevas == null ? errorEstadisticas : null,
      clearError: estadisticasNuevas != null,
      resumen: resumenNuevo,
      clearResumen: resumenNuevo == null,
    );
  }
}
