//lib/features/monitoring/data/datasources/monitoring_remote_datasource.dart
import '../../../../core/network/api_client.dart';
import '../../../../core/storage/secure_storage.dart';
import '../models/lectura_model.dart';
import '../models/estadisticas_model.dart';

/// Llamadas HTTP puras a /lotes/{id}/lecturas y /lotes/{id}/estadisticas.
/// No maneja estado de UI.
abstract class MonitoringRemoteDataSource {
  Future<List<LecturaModel>> getLecturas(int loteId);
  Future<EstadisticasModel> getEstadisticas(int loteId);
}

class MonitoringRemoteDataSourceImpl implements MonitoringRemoteDataSource {
  final ApiClient apiClient;
  final SecureStorage secureStorage;

  MonitoringRemoteDataSourceImpl(this.apiClient, this.secureStorage);

  @override
  Future<List<LecturaModel>> getLecturas(int loteId) async {
    final token = await secureStorage.getAccessToken();

    if (token == null) {
      throw const ApiException(
        'Sesión expirada. Inicia sesión de nuevo.',
        statusCode: 401,
      );
    }

    final response = await apiClient.getList(
      '/lotes/$loteId/lecturas',
      token: token,
    );

    return response
        .map((e) => LecturaModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<EstadisticasModel> getEstadisticas(int loteId) async {
    final token = await secureStorage.getAccessToken();

    if (token == null) {
      throw const ApiException(
        'Sesión expirada. Inicia sesión de nuevo.',
        statusCode: 401,
      );
    }

    final response = await apiClient.get(
      '/lotes/$loteId/estadisticas',
      token: token,
    );

    return EstadisticasModel.fromJson(response);
  }
}
