//lib/features/sensors/data/repositories/sensors_repository_impl.dart
import 'package:injectable/injectable.dart';

import '../../domain/repositories/sensors_repository.dart';
import '../datasources/sensor_status_remote_datasource.dart';
import '../models/sensor_model.dart';

@LazySingleton(as: SensorsRepository)
class SensorsRepositoryImpl implements SensorsRepository {
  final SensorStatusDataSource remoteDataSource;

  SensorsRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<SensorModel>> getEstadoSensores() {
    return remoteDataSource.getEstadoSensores();
  }
}
