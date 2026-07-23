import '../entities/archivo_descargado_entity.dart';
import '../entities/reporte_entity.dart';
import '../entities/reporte_narrativo_entity.dart';

abstract class ReportsRepository {
  Future<List<ReporteEntity>> getReportes();

  Future<ReporteEntity> solicitarReporte({
    required int idLote,
    required String tipoReporte,
    required String formato,
  });

  Future<ArchivoDescargadoEntity> descargarArchivo(String urlArchivo);

  Future<ReporteNarrativoEntity> obtenerReporteNarrativo(int idLote);
}
