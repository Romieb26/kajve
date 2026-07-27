import 'package:injectable/injectable.dart';

import '../entities/lote_reclamado_entity.dart';
import '../repositories/lote_reclamo_repository.dart';

@injectable
class ReclamarLoteUseCase {
  final LoteReclamoRepository repository;

  ReclamarLoteUseCase(this.repository);

  Future<LoteReclamadoEntity> call(String codigoQr) {
    return repository.reclamarLote(codigoQr);
  }
}
