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

    // limit=15: la pantalla de predicciones solo necesita las más recientes/relevantes para el
    // historial visible, no cada predicción que se haya generado en toda la vida del lote (eso
    // era lo que causaba el lag reportado -- cientos de filas renderizadas de golpe). Go ya
    // defaultea a 15 si se omite este parámetro, pero se manda explícito para no depender de
    // ese default.
    final response = await apiClient.getList(
      '/lotes/$loteId/predicciones?limit=15',
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
