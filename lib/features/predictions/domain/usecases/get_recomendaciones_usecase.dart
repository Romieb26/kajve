import '../entities/recomendacion_entity.dart';
import '../repositories/predictions_repository.dart';

class GetRecomendacionesUseCase {
  final PredictionsRepository repository;

  GetRecomendacionesUseCase(this.repository);

  Future<List<RecomendacionEntity>> call(int loteId) {
    return repository.getRecomendaciones(loteId);
  }
}
