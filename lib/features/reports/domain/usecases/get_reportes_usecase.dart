import '../entities/reporte_entity.dart';
import '../repositories/reports_repository.dart';

class GetReportesUseCase {
  final ReportsRepository repository;

  GetReportesUseCase(this.repository);

  Future<List<ReporteEntity>> call() {
    return repository.getReportes();
  }
}
