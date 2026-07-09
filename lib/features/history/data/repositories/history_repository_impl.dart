import '../../domain/entities/historial_evento_entity.dart';
import '../../domain/repositories/history_repository.dart';
import '../datasources/history_remote_datasource.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  final HistoryRemoteDataSource remoteDataSource;

  HistoryRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<HistorialEventoEntity>> getHistorial(int loteId) {
    return remoteDataSource.getHistorial(loteId);
  }
}
