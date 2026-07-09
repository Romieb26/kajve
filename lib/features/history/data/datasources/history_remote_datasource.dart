import '../../../../core/network/api_client.dart';
import '../../../../core/storage/secure_storage.dart';
import '../models/historial_evento_model.dart';

/// Llamadas HTTP puras a /lotes/{id}/historial. No maneja estado de UI.
abstract class HistoryRemoteDataSource {
  Future<List<HistorialEventoModel>> getHistorial(int loteId);
}

class HistoryRemoteDataSourceImpl implements HistoryRemoteDataSource {
  final ApiClient apiClient;
  final SecureStorage secureStorage;

  HistoryRemoteDataSourceImpl(this.apiClient, this.secureStorage);

  @override
  Future<List<HistorialEventoModel>> getHistorial(int loteId) async {
    final token = await secureStorage.getAccessToken();

    if (token == null) {
      throw const ApiException(
        'Sesión expirada. Inicia sesión de nuevo.',
        statusCode: 401,
      );
    }

    final response = await apiClient.getList(
      '/lotes/$loteId/historial',
      token: token,
    );

    return response
        .map((e) => HistorialEventoModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
