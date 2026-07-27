import 'package:injectable/injectable.dart';

import '../repositories/alerts_repository.dart';

@injectable
class AtenderAlertaUseCase {
  final AlertsRepository repository;

  AtenderAlertaUseCase(this.repository);

  Future<void> call(int alertaId) {
    return repository.atenderAlerta(alertaId);
  }
}
