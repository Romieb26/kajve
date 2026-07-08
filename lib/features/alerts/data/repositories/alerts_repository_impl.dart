import '../../domain/entities/alerta_entity.dart';
import '../../domain/repositories/alerts_repository.dart';
import '../datasources/alerts_remote_datasource.dart';

class AlertsRepositoryImpl implements AlertsRepository {
  final AlertsRemoteDataSource remoteDataSource;

  AlertsRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<AlertaEntity>> getAlertas(int loteId) {
    return remoteDataSource.getAlertas(loteId);
  }

  @override
  Future<void> atenderAlerta(int alertaId) {
    return remoteDataSource.atenderAlerta(alertaId);
  }
}
