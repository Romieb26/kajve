import 'package:injectable/injectable.dart';

import '../entities/alerta_entity.dart';
import '../repositories/alerts_repository.dart';

@injectable
class GetAlertasUseCase {
  final AlertsRepository repository;

  GetAlertasUseCase(this.repository);

  Future<List<AlertaEntity>> call(int loteId) {
    return repository.getAlertas(loteId);
  }
}
