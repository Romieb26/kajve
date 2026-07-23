import '../entities/reporte_narrativo_entity.dart';
import '../repositories/reports_repository.dart';

class ObtenerReporteNarrativoUseCase {
  final ReportsRepository repository;

  ObtenerReporteNarrativoUseCase(this.repository);

  Future<ReporteNarrativoEntity> call(int idLote) {
    return repository.obtenerReporteNarrativo(idLote);
  }
}
