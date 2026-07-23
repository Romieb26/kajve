import '../../domain/entities/archivo_descargado_entity.dart';
import '../../domain/entities/reporte_entity.dart';
import '../../domain/entities/reporte_narrativo_entity.dart';
import '../../domain/repositories/reports_repository.dart';
import '../datasources/reports_remote_datasource.dart';

class ReportsRepositoryImpl implements ReportsRepository {
  final ReportsRemoteDataSource remoteDataSource;

  ReportsRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<ReporteEntity>> getReportes() {
    return remoteDataSource.getReportes();
  }

  @override
  Future<ReporteEntity> solicitarReporte({
    required int idLote,
    required String tipoReporte,
    required String formato,
  }) {
    return remoteDataSource.solicitarReporte(
      idLote: idLote,
      tipoReporte: tipoReporte,
      formato: formato,
    );
  }

  @override
  Future<ArchivoDescargadoEntity> descargarArchivo(String urlArchivo) async {
    final resultado = await remoteDataSource.descargarArchivo(urlArchivo);

    return ArchivoDescargadoEntity(
      bytes: resultado.bytes,
      contentType: resultado.contentType,
      fileName: resultado.fileName,
    );
  }

  @override
  Future<ReporteNarrativoEntity> obtenerReporteNarrativo(int idLote) {
    return remoteDataSource.obtenerReporteNarrativo(idLote);
  }
}
