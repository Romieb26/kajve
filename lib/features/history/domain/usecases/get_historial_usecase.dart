import '../entities/historial_evento_entity.dart';
import '../repositories/history_repository.dart';

class GetHistorialUseCase {
  final HistoryRepository repository;

  GetHistorialUseCase(this.repository);

  Future<List<HistorialEventoEntity>> call(int loteId) {
    return repository.getHistorial(loteId);
  }
}
