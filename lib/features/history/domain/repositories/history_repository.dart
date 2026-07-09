import '../entities/historial_evento_entity.dart';

abstract class HistoryRepository {
  Future<List<HistorialEventoEntity>> getHistorial(int loteId);
}
