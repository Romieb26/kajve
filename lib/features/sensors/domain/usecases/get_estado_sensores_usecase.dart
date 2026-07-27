//lib/features/sensors/domain/usecases/get_estado_sensores_usecase.dart
import 'package:injectable/injectable.dart';

import '../../data/models/sensor_model.dart';
import '../repositories/sensors_repository.dart';

@injectable
class GetEstadoSensoresUseCase {
  final SensorsRepository repository;

  GetEstadoSensoresUseCase(this.repository);

  Future<List<SensorModel>> call() {
    return repository.getEstadoSensores();
  }
}
