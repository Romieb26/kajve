//lib/features/monitoring/presentation/providers/monitoring_provider.dart
import 'package:flutter/material.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../data/datasources/monitoring_remote_datasource.dart';
import '../../data/datasources/resumen_lote_remote_datasource.dart';
import '../../data/repositories/monitoring_repository_impl.dart';
import '../../domain/entities/estadisticas_entity.dart';
import '../../domain/entities/lectura_entity.dart';
import '../../domain/entities/resumen_lote_entity.dart';
import '../../domain/usecases/get_estadisticas_usecase.dart';
import '../../domain/usecases/get_lecturas_usecase.dart';

class MonitoringProvider extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;

  List<LecturaEntity> lecturas = [];
  EstadisticasEntity? estadisticas;

  /// Resumen del lote completo (min/prom/max de TODAS las lecturas),
  /// calculado en ws-gateway — no depende de api-mobile, así que no se ve
  /// afectado por el error 500 de /lotes/{id}/estadisticas.
  ResumenLoteEntity? resumen;

  int? _loteIdActual;

  late final MonitoringRepositoryImpl _repository = MonitoringRepositoryImpl(
    MonitoringRemoteDataSourceImpl(ApiClient(), SecureStorage()),
  );

  late final GetLecturasUseCase _getLecturasUseCase = GetLecturasUseCase(
    _repository,
  );

  late final GetEstadisticasUseCase _getEstadisticasUseCase =
      GetEstadisticasUseCase(_repository);

  final ResumenLoteRemoteDataSource _resumenDataSource =
      ResumenLoteRemoteDataSource();

  Future<void> cargarDatos(int loteId) async {
    // Si es un lote distinto al que ya estaba cargado, se limpian los
    // datos antes de esperar la respuesta: si la petición falla, la UI
    // nunca debe seguir mostrando datos de un lote distinto al que el
    // usuario está viendo (el provider es un singleton compartido entre
    // lotes, ver main.dart). Si es el mismo lote (ej. un tick del
    // auto-refresh), se dejan los datos anteriores visibles mientras se
    // espera, para no parpadear a un estado vacío en cada refresco.
    if (loteId != _loteIdActual) {
      lecturas = [];
      estadisticas = null;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    // Se piden por separado (no con Future.wait) para que un fallo en
    // /lecturas no tumbe también /estadisticas: antes, si cualquiera de
    // las dos fallaba, la pantalla completa se quedaba en "no se pudo
    // conectar" aunque la otra sí hubiera respondido bien. Las
    // estadísticas son lo importante de esta pantalla; las lecturas solo
    // se usan para saber si mostrar el aviso de "sin lecturas".
    EstadisticasEntity? estadisticasNuevas;
    String? errorEstadisticas;
    try {
      estadisticasNuevas = await _getEstadisticasUseCase(loteId);
    } on ApiException catch (e) {
      errorEstadisticas = mensajeAmigable(e);
    } catch (_) {
      errorEstadisticas = "Ocurrió un error al cargar el monitoreo.";
    }

    try {
      lecturas = await _getLecturasUseCase(loteId);
    } catch (_) {
      // No es crítico: si falla, simplemente se asume "sin lecturas" en
      // vez de tumbar toda la pantalla.
      lecturas = [];
    }

    // El resumen viene de ws-gateway (Postgres directo), no de api-mobile:
    // se pide siempre, incluso si /estadisticas falló arriba, porque no
    // comparten backend ni pueden fallar por la misma causa.
    try {
      resumen = await _resumenDataSource.getResumen(loteId);
    } catch (_) {
      resumen = null;
    }

    estadisticas = estadisticasNuevas;
    errorMessage = estadisticasNuevas == null ? errorEstadisticas : null;

    _loteIdActual = loteId;
    isLoading = false;
    notifyListeners();
  }
}
