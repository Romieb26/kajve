import 'package:flutter/material.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../data/datasources/predictions_remote_datasource.dart';
import '../../data/repositories/predictions_repository_impl.dart';
import '../../domain/entities/prediccion_entity.dart';
import '../../domain/entities/recomendacion_entity.dart';
import '../../domain/usecases/get_predicciones_usecase.dart';
import '../../domain/usecases/get_recomendaciones_usecase.dart';

class PredictionProvider extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;

  List<PrediccionEntity> predicciones = [];
  List<RecomendacionEntity> recomendaciones = [];

  late final PredictionsRepositoryImpl _repository =
      PredictionsRepositoryImpl(
        PredictionsRemoteDataSourceImpl(ApiClient(), SecureStorage()),
      );

  late final GetPrediccionesUseCase _getPrediccionesUseCase =
      GetPrediccionesUseCase(_repository);

  late final GetRecomendacionesUseCase _getRecomendacionesUseCase =
      GetRecomendacionesUseCase(_repository);

  Future<void> cargarDatos(int loteId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final resultados = await Future.wait([
        _getPrediccionesUseCase(loteId),
        _getRecomendacionesUseCase(loteId),
      ]);

      // Confirmado (ya no es un TODO abierto):
      // 1) "confianza" viene del backend 0-100, no como fracción -- ver
      //    app/services/predictor.py del microservicio de ML.
      // 2) el array viene en orden DESCENDENTE por fecha (Go:
      //    prediccion_repository.go, ORDER BY fecha_prediccion DESC), así
      //    que el elemento más reciente es predicciones.first, no
      //    predicciones.last -- ver prediction_page.dart.
      predicciones = resultados[0] as List<PrediccionEntity>;
      recomendaciones = resultados[1] as List<RecomendacionEntity>;
    } on ApiException catch (e) {
      debugPrint('Error real predicciones: $e (statusCode: ${e.statusCode})');
      errorMessage = e.statusCode == 401
          ? "Tu sesión expiró. Inicia sesión de nuevo."
          : "No se pudo conectar. Intenta de nuevo";
    } catch (e) {
      debugPrint('Error real predicciones (no-ApiException): $e');
      errorMessage = "Ocurrió un error al cargar las predicciones.";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
