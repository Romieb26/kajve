import '../entities/archivo_descargado_entity.dart';
import '../repositories/reports_repository.dart';

class DescargarReporteUseCase {
  final ReportsRepository repository;

  DescargarReporteUseCase(this.repository);

  Future<ArchivoDescargadoEntity> call(String urlArchivo) {
    return repository.descargarArchivo(urlArchivo);
  }
}
