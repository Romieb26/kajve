//lib/features/sensors/domain/repositories/sensors_repository.dart
import '../../data/models/sensor_model.dart';

abstract class SensorsRepository {
  Future<List<SensorModel>> getEstadoSensores();
}
