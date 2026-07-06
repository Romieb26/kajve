import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../../monitoring/data/datasources/monitoring_remote_datasource.dart';
import '../../../monitoring/data/repositories/monitoring_repository_impl.dart';
import '../../../monitoring/domain/entities/estadisticas_entity.dart';
import '../../../monitoring/domain/entities/lectura_entity.dart';
import '../../../monitoring/domain/usecases/get_estadisticas_usecase.dart';
import '../../../monitoring/domain/usecases/get_lecturas_usecase.dart';

class RealtimeProvider extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;

  List<LecturaEntity> lecturas = [];
  EstadisticasEntity? estadisticas;

  Timer? _autoRefreshTimer;

  late final MonitoringRepositoryImpl _repository = MonitoringRepositoryImpl(
    MonitoringRemoteDataSourceImpl(ApiClient(), SecureStorage()),
  );

  late final GetLecturasUseCase _getLecturasUseCase = GetLecturasUseCase(
    _repository,
  );

  late final GetEstadisticasUseCase _getEstadisticasUseCase =
      GetEstadisticasUseCase(_repository);

  Future<void> cargarDatos(int loteId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final resultados = await Future.wait([
        _getLecturasUseCase(loteId),
        _getEstadisticasUseCase(loteId),
      ]);

      lecturas = resultados[0] as List<LecturaEntity>;
      estadisticas = resultados[1] as EstadisticasEntity;
    } on ApiException catch (e) {
      errorMessage = e.statusCode == 401
          ? "Tu sesión expiró. Inicia sesión de nuevo."
          : "No se pudo conectar. Intenta de nuevo";
    } catch (_) {
      errorMessage = "Ocurrió un error al cargar el monitoreo.";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void iniciarAutoRefresh(int loteId) {
    detenerAutoRefresh();
    _autoRefreshTimer = Timer.periodic(
      const Duration(seconds: 20),
      (_) => cargarDatos(loteId),
    );
  }

  void detenerAutoRefresh() {
    _autoRefreshTimer?.cancel();
    _autoRefreshTimer = null;
  }

  @override
  void dispose() {
    detenerAutoRefresh();
    super.dispose();
  }
}
