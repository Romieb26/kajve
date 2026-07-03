import 'entities/lote_entity.dart';
import 'repositories/lots_repository.dart';

class CreateLoteUseCase {
  final LotsRepository repository;

  CreateLoteUseCase(this.repository);

  Future<LoteEntity> call({
    required String nombreLote,
    required String variedad,
    required String tipoProceso,
    required double pesoKg,
    required String ubicacion,
    int? idSensor,
  }) {
    return repository.createLote(
      nombreLote: nombreLote,
      variedad: variedad,
      tipoProceso: tipoProceso,
      pesoKg: pesoKg,
      ubicacion: ubicacion,
      idSensor: idSensor,
    );
  }
}
