import '../../domain/entities/prediccion_entity.dart';

class PrediccionModel extends PrediccionEntity {
  const PrediccionModel({
    required super.idPrediccion,
    required super.loteId,
    required super.tiempoEstimadoHoras,
    required super.calidadEstimada,
    required super.confianza,
    super.fechaPrediccion,
    super.modeloVersion,
  });

  factory PrediccionModel.fromJson(Map<String, dynamic> json) {
    return PrediccionModel(
      idPrediccion: json['id_prediccion'] as int? ?? 0,
      loteId: json['lote_id'] as int? ?? 0,
      tiempoEstimadoHoras:
          (json['tiempo_estimado_horas'] as num?)?.toDouble() ?? 0.0,
      calidadEstimada: json['calidad_estimada'] as String? ?? '',
      confianza: (json['confianza'] as num?)?.toDouble() ?? 0.0,
      fechaPrediccion: json['fecha_prediccion'] as String?,
      modeloVersion: json['modelo_version'] as String?,
    );
  }
}
