import '../../domain/entities/lote_entity.dart';
import '../../domain/repositories/lots_repository.dart';
import '../datasources/lots_remote_datasource.dart';
import '../models/create_lote_request_model.dart';

class LotsRepositoryImpl implements LotsRepository {
  final LotsRemoteDataSource remoteDataSource;

  LotsRepositoryImpl(this.remoteDataSource);

  @override
  Future<LoteEntity> createLote({
    required String nombreLote,
    required String variedad,
    required String tipoProceso,
    required double pesoKg,
    required String ubicacion,
    int? idSensor,
  }) {
    return remoteDataSource.createLote(
      CreateLoteRequestModel(
        nombreLote: nombreLote,
        variedad: variedad,
        tipoProceso: tipoProceso,
        pesoKg: pesoKg,
        ubicacion: ubicacion,
        idSensor: idSensor,
      ),
    );
  }
}
