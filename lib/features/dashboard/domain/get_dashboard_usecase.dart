import 'entities/dashboard_entity.dart';
import 'repositories/dashboard_repository.dart';

class GetDashboardUseCase {
  final DashboardRepository repository;

  GetDashboardUseCase(this.repository);

  Future<DashboardEntity> call() {
    return repository.getDashboard();
  }
}
