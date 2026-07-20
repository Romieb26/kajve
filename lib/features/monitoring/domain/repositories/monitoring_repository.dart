//lib/features/monitoring/domain/repositories/monitoring_repository.dart
import '../entities/lectura_entity.dart';
import '../entities/estadisticas_entity.dart';

abstract class MonitoringRepository {
  Future<List<LecturaEntity>> getLecturas(int loteId);
  Future<EstadisticasEntity> getEstadisticas(int loteId);
}
