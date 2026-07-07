import '../../../../core/network/api_client.dart';
import '../../../../core/storage/secure_storage.dart';
import '../models/lot_model.dart';

/// Llamada HTTP pura a GET /lotes. No maneja estado de UI.
abstract class LotRemoteDataSource {
  Future<List<LotModel>> getLotes();
}

class LotRemoteDataSourceImpl implements LotRemoteDataSource {
  final ApiClient apiClient;
  final SecureStorage secureStorage;

  LotRemoteDataSourceImpl(this.apiClient, this.secureStorage);

  @override
  Future<List<LotModel>> getLotes() async {
    final token = await secureStorage.getAccessToken();

    if (token == null) {
      throw const ApiException(
        'Sesión expirada. Inicia sesión de nuevo.',
        statusCode: 401,
      );
    }

    // GET /lotes no devuelve un array en la raíz: viene envuelto en un
    // objeto paginado ({"data": [...], "total", "page", "limit"}).
    final response = await apiClient.get('/lotes', token: token);
    final data = response['data'] as List<dynamic>? ?? [];

    return data
        .map((e) => LotModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
