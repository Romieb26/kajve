import 'package:injectable/injectable.dart';

import '../entities/prediccion_entity.dart';
import '../repositories/predictions_repository.dart';

@injectable
class GetPrediccionesUseCase {
  final PredictionsRepository repository;

  GetPrediccionesUseCase(this.repository);

  Future<List<PrediccionEntity>> call(int loteId) {
    return repository.getPredicciones(loteId);
  }
}
