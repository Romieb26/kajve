//lib/features/monitoring/domain/usecases/get_resumen_lote_usecase.dart
import 'package:injectable/injectable.dart';

import '../entities/resumen_lote_entity.dart';
import '../repositories/monitoring_repository.dart';

@injectable
class GetResumenLoteUseCase {
  final MonitoringRepository repository;

  GetResumenLoteUseCase(this.repository);

  Future<ResumenLoteEntity> call(int loteId) {
    return repository.getResumen(loteId);
  }
}
