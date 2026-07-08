import '../entities/alerta_entity.dart';
import '../repositories/alerts_repository.dart';

class GetAlertasUseCase {
  final AlertsRepository repository;

  GetAlertasUseCase(this.repository);

  Future<List<AlertaEntity>> call(int loteId) {
    return repository.getAlertas(loteId);
  }
}
