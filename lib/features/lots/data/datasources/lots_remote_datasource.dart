import '../../../../core/network/api_client.dart';
import '../../../../core/storage/secure_storage.dart';
import '../models/create_lote_request_model.dart';
import '../models/lote_response_model.dart';

/// Llamada HTTP pura a POST /lotes. No maneja estado de UI.
abstract class LotsRemoteDataSource {
  Future<LoteResponseModel> createLote(CreateLoteRequestModel request);
}

class LotsRemoteDataSourceImpl implements LotsRemoteDataSource {
  final ApiClient apiClient;
  final SecureStorage secureStorage;

  LotsRemoteDataSourceImpl(this.apiClient, this.secureStorage);

  @override
  Future<LoteResponseModel> createLote(CreateLoteRequestModel request) async {
    final token = await secureStorage.getAccessToken();

    if (token == null) {
      throw const ApiException(
        'Sesión expirada. Inicia sesión de nuevo.',
        statusCode: 401,
      );
    }

    final json = await apiClient.post(
      '/lotes',
      body: request.toJson(),
      token: token,
    );

    return LoteResponseModel.fromJson(json);
  }
}
