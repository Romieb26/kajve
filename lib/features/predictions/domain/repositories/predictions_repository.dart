import '../entities/prediccion_entity.dart';
import '../entities/recomendacion_entity.dart';

abstract class PredictionsRepository {
  Future<List<PrediccionEntity>> getPredicciones(int loteId);
  Future<List<RecomendacionEntity>> getRecomendaciones(int loteId);
}
