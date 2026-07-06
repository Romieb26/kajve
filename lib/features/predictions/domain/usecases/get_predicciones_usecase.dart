import '../entities/prediccion_entity.dart';
import '../repositories/predictions_repository.dart';

class GetPrediccionesUseCase {
  final PredictionsRepository repository;

  GetPrediccionesUseCase(this.repository);

  Future<List<PrediccionEntity>> call(int loteId) {
    return repository.getPredicciones(loteId);
  }
}
