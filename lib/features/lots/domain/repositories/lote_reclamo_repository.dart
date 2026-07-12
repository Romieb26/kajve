import '../entities/lote_reclamado_entity.dart';

abstract class LoteReclamoRepository {
  Future<LoteReclamadoEntity> reclamarLote(String codigoQr);
}
