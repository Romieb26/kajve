import '../../domain/entities/prediccion_entity.dart';
import '../../domain/entities/recomendacion_entity.dart';
import '../../domain/repositories/predictions_repository.dart';
import '../datasources/predictions_remote_datasource.dart';

class PredictionsRepositoryImpl implements PredictionsRepository {
  final PredictionsRemoteDataSource remoteDataSource;

  PredictionsRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<PrediccionEntity>> getPredicciones(int loteId) {
    return remoteDataSource.getPredicciones(loteId);
  }

  @override
  Future<List<RecomendacionEntity>> getRecomendaciones(int loteId) {
    return remoteDataSource.getRecomendaciones(loteId);
  }
}
