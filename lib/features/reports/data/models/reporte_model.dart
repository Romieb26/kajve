import '../../domain/entities/reporte_entity.dart';

class ReporteModel extends ReporteEntity {
  const ReporteModel({
    required super.id,
    required super.idLote,
    required super.idUsuario,
    required super.tipoReporte,
    required super.formato,
    super.urlArchivo,
    required super.fechaGeneracion,
  });

  factory ReporteModel.fromJson(Map<String, dynamic> json) {
    return ReporteModel(
      id: json['id'] as int,
      idLote: json['id_lote'] as int,
      idUsuario: json['id_usuario'] as int,
      tipoReporte: json['tipo_reporte'] as String? ?? '',
      formato: json['formato'] as String? ?? '',
      urlArchivo: json['url_archivo'] as String?,
      fechaGeneracion: json['fecha_generacion'] as String? ?? '',
    );
  }
}
