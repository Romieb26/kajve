import 'package:injectable/injectable.dart';

import '../entities/recomendacion_entity.dart';
import '../repositories/predictions_repository.dart';

@injectable
class GetRecomendacionesUseCase {
  final PredictionsRepository repository;

  GetRecomendacionesUseCase(this.repository);

  Future<List<RecomendacionEntity>> call(int loteId) {
    return repository.getRecomendaciones(loteId);
  }
}
