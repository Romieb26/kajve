import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/prediccion_entity.dart';
import '../../domain/entities/recomendacion_entity.dart';
import '../../domain/usecases/get_predicciones_usecase.dart';
import '../../domain/usecases/get_recomendaciones_usecase.dart';

part 'prediction_provider.g.dart';

class PredictionState {
  final bool isLoading;
  final String? errorMessage;
  final List<PrediccionEntity> predicciones;
  final List<RecomendacionEntity> recomendaciones;

  const PredictionState({
    this.isLoading = false,
    this.errorMessage,
    this.predicciones = const [],
    this.recomendaciones = const [],
  });

  PredictionState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
    List<PrediccionEntity>? predicciones,
    List<RecomendacionEntity>? recomendaciones,
  }) {
    return PredictionState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      predicciones: predicciones ?? this.predicciones,
      recomendaciones: recomendaciones ?? this.recomendaciones,
    );
  }
}

@riverpod
class PredictionController extends _$PredictionController {
  @override
  PredictionState build() => const PredictionState();

  Future<void> cargarDatos(int loteId) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final resultados = await Future.wait([
        getIt<GetPrediccionesUseCase>()(loteId),
        getIt<GetRecomendacionesUseCase>()(loteId),
      ]);

      // Confirmado (ya no es un TODO abierto):
      // 1) "confianza" viene del backend 0-100, no como fracción -- ver
      //    app/services/predictor.py del microservicio de ML.
      // 2) el array viene en orden DESCENDENTE por fecha (Go:
      //    prediccion_repository.go, ORDER BY fecha_prediccion DESC), así
      //    que el elemento más reciente es predicciones.first, no
      //    predicciones.last -- ver prediction_page.dart.
      state = state.copyWith(
        predicciones: resultados[0] as List<PrediccionEntity>,
        recomendaciones: resultados[1] as List<RecomendacionEntity>,
      );
    } on ApiException catch (e) {
      debugPrint('Error real predicciones: $e (statusCode: ${e.statusCode})');
      state = state.copyWith(
        errorMessage: e.statusCode == 401
            ? "Tu sesión expiró. Inicia sesión de nuevo."
            : "No se pudo conectar. Intenta de nuevo",
      );
    } catch (e) {
      debugPrint('Error real predicciones (no-ApiException): $e');
      state = state.copyWith(
        errorMessage: "Ocurrió un error al cargar las predicciones.",
      );
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}
