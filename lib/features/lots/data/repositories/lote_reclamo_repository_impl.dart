import '../../domain/entities/lote_reclamado_entity.dart';
import '../../domain/repositories/lote_reclamo_repository.dart';
import '../datasources/lote_reclamo_remote_datasource.dart';

class LoteReclamoRepositoryImpl implements LoteReclamoRepository {
  final LoteReclamoRemoteDataSource remoteDataSource;

  LoteReclamoRepositoryImpl(this.remoteDataSource);

  @override
  Future<LoteReclamadoEntity> reclamarLote(String codigoQr) {
    return remoteDataSource.reclamarLote(codigoQr);
  }
}
