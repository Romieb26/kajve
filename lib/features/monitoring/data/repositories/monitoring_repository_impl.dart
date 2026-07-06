import '../../domain/entities/estadisticas_entity.dart';
import '../../domain/entities/lectura_entity.dart';
import '../../domain/repositories/monitoring_repository.dart';
import '../datasources/monitoring_remote_datasource.dart';

class MonitoringRepositoryImpl implements MonitoringRepository {
  final MonitoringRemoteDataSource remoteDataSource;

  MonitoringRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<LecturaEntity>> getLecturas(int loteId) {
    return remoteDataSource.getLecturas(loteId);
  }

  @override
  Future<EstadisticasEntity> getEstadisticas(int loteId) {
    return remoteDataSource.getEstadisticas(loteId);
  }
}
