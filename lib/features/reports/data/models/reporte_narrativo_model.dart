import '../../domain/entities/reporte_narrativo_entity.dart';

class ReporteNarrativoModel extends ReporteNarrativoEntity {
  const ReporteNarrativoModel({
    required super.idReporte,
    required super.idLote,
    required super.reporteTexto,
    required super.fechaGenerado,
  });

  factory ReporteNarrativoModel.fromJson(Map<String, dynamic> json) {
    return ReporteNarrativoModel(
      idReporte: json['id_reporte'] as int? ?? 0,
      idLote: json['id_lote'] as int? ?? 0,
      reporteTexto: json['reporte_texto'] as String? ?? '',
      fechaGenerado: json['fecha_generado'] as String? ?? '',
    );
  }
}
