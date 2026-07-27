//lib/features/monitoring/domain/usecases/get_estadisticas_usecase.dart
import 'package:injectable/injectable.dart';

import '../entities/estadisticas_entity.dart';
import '../repositories/monitoring_repository.dart';

@injectable
class GetEstadisticasUseCase {
  final MonitoringRepository repository;

  GetEstadisticasUseCase(this.repository);

  Future<EstadisticasEntity> call(int loteId) {
    return repository.getEstadisticas(loteId);
  }
}
