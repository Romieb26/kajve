import '../../../../core/network/api_client.dart';
import '../../../../core/storage/secure_storage.dart';
import '../models/prediccion_model.dart';
import '../models/recomendacion_model.dart';

/// Llamadas HTTP puras a /lotes/{id}/predicciones y
/// /lotes/{id}/recomendaciones. No maneja estado de UI.
abstract class PredictionsRemoteDataSource {
  Future<List<PrediccionModel>> getPredicciones(int loteId);
  Future<List<RecomendacionModel>> getRecomendaciones(int loteId);
}

class PredictionsRemoteDataSourceImpl implements PredictionsRemoteDataSource {
  final ApiClient apiClient;
  final SecureStorage secureStorage;

  PredictionsRemoteDataSourceImpl(this.apiClient, this.secureStorage);

  @override
  Future<List<PrediccionModel>> getPredicciones(int loteId) async {
    final token = await secureStorage.getAccessToken();

    if (token == null) {
      throw const ApiException(
        'Sesión expirada. Inicia sesión de nuevo.',
        statusCode: 401,
      );
    }

    final response = await apiClient.getList(
      '/lotes/$loteId/predicciones',
      token: token,
    );

    return response
        .map((e) => PrediccionModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<RecomendacionModel>> getRecomendaciones(int loteId) async {
    final token = await secureStorage.getAccessToken();

    if (token == null) {
      throw const ApiException(
        'Sesión expirada. Inicia sesión de nuevo.',
        statusCode: 401,
      );
    }

    final response = await apiClient.getList(
      '/lotes/$loteId/recomendaciones',
      token: token,
    );

    return response
        .map((e) => RecomendacionModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
