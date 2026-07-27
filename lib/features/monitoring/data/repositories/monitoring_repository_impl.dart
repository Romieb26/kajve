//lib/features/monitoring/data/repositories/monitoring_repository_impl.dart
import 'package:injectable/injectable.dart';

import '../../domain/entities/estadisticas_entity.dart';
import '../../domain/entities/lectura_entity.dart';
import '../../domain/entities/resumen_lote_entity.dart';
import '../../domain/repositories/monitoring_repository.dart';
import '../datasources/monitoring_remote_datasource.dart';
import '../datasources/resumen_lote_remote_datasource.dart';

@LazySingleton(as: MonitoringRepository)
class MonitoringRepositoryImpl implements MonitoringRepository {
  final MonitoringRemoteDataSource remoteDataSource;
  final ResumenLoteRemoteDataSource resumenDataSource;

  MonitoringRepositoryImpl(this.remoteDataSource, this.resumenDataSource);

  @override
  Future<List<LecturaEntity>> getLecturas(int loteId) {
    return remoteDataSource.getLecturas(loteId);
  }

  @override
  Future<EstadisticasEntity> getEstadisticas(int loteId) {
    return remoteDataSource.getEstadisticas(loteId);
  }

  @override
  Future<ResumenLoteEntity> getResumen(int loteId) {
    return resumenDataSource.getResumen(loteId);
  }
}
