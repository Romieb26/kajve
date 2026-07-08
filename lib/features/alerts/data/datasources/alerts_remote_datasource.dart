import '../../../../core/network/api_client.dart';
import '../../../../core/storage/secure_storage.dart';
import '../models/alerta_model.dart';

/// Llamadas HTTP puras a /lotes/{id}/alertas y /alertas/{id}/atender.
/// No maneja estado de UI.
abstract class AlertsRemoteDataSource {
  Future<List<AlertaModel>> getAlertas(int loteId);
  Future<AlertaModel> atenderAlerta(int alertaId);
}

class AlertsRemoteDataSourceImpl implements AlertsRemoteDataSource {
  final ApiClient apiClient;
  final SecureStorage secureStorage;

  AlertsRemoteDataSourceImpl(this.apiClient, this.secureStorage);

  @override
  Future<List<AlertaModel>> getAlertas(int loteId) async {
    final token = await secureStorage.getAccessToken();

    if (token == null) {
      throw const ApiException(
        'Sesión expirada. Inicia sesión de nuevo.',
        statusCode: 401,
      );
    }

    final response = await apiClient.getList(
      '/lotes/$loteId/alertas',
      token: token,
    );

    return response
        .map((e) => AlertaModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<AlertaModel> atenderAlerta(int alertaId) async {
    final token = await secureStorage.getAccessToken();

    if (token == null) {
      throw const ApiException(
        'Sesión expirada. Inicia sesión de nuevo.',
        statusCode: 401,
      );
    }

    final response = await apiClient.put(
      '/alertas/$alertaId/atender',
      token: token,
    );

    return AlertaModel.fromJson(response);
  }
}
