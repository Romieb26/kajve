import '../entities/lote_entity.dart';

abstract class LotsRepository {
  Future<LoteEntity> createLote({
    required String nombreLote,
    required String variedad,
    required String tipoProceso,
    required double pesoKg,
    required String ubicacion,
    int? idSensor,
  });
}
