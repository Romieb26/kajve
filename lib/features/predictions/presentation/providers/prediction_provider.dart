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

  bool _confianzaLogueada = false;

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

      predicciones = resultados[0] as List<PrediccionEntity>;
      recomendaciones = resultados[1] as List<RecomendacionEntity>;

      // TODO: quitar este print de diagnóstico en cuanto confirmemos:
      // 1) si "confianza" viene del backend como fracción (0-1) o ya
      //    como porcentaje (0-100).
      // 2) el orden real del array (hoy se asume ascendente y se usa
      //    predicciones.last como "la más reciente" en el provider y
      //    en prediction_page.dart) — comparando first vs last se ve
      //    cuál fecha es cronológicamente más nueva.
      if (!_confianzaLogueada && predicciones.isNotEmpty) {
        _confianzaLogueada = true;
        debugPrint(
          'PredictionProvider: confianza cruda de la predicción más '
          'reciente = ${predicciones.last.confianza}',
        );
        debugPrint(
          'PredictionProvider: fechaPrediccion primer elemento del '
          'array = ${predicciones.first.fechaPrediccion}',
        );
        debugPrint(
          'PredictionProvider: fechaPrediccion último elemento del '
          'array = ${predicciones.last.fechaPrediccion}',
        );
      }
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
