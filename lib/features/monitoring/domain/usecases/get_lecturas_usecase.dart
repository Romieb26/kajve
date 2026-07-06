import '../entities/lectura_entity.dart';
import '../repositories/monitoring_repository.dart';

class GetLecturasUseCase {
  final MonitoringRepository repository;

  GetLecturasUseCase(this.repository);

  Future<List<LecturaEntity>> call(int loteId) {
    return repository.getLecturas(loteId);
  }
}
