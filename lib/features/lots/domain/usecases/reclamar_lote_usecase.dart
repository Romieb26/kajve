import '../entities/lote_reclamado_entity.dart';
import '../repositories/lote_reclamo_repository.dart';

class ReclamarLoteUseCase {
  final LoteReclamoRepository repository;

  ReclamarLoteUseCase(this.repository);

  Future<LoteReclamadoEntity> call(String codigoQr) {
    return repository.reclamarLote(codigoQr);
  }
}
