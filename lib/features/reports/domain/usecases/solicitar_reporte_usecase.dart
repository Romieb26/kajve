import '../entities/reporte_entity.dart';
import '../repositories/reports_repository.dart';

class SolicitarReporteUseCase {
  final ReportsRepository repository;

  SolicitarReporteUseCase(this.repository);

  Future<ReporteEntity> call({
    required int idLote,
    required String tipoReporte,
    required String formato,
  }) {
    return repository.solicitarReporte(
      idLote: idLote,
      tipoReporte: tipoReporte,
      formato: formato,
    );
  }
}
