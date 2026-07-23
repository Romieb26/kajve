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
    super.riesgoLluviaProxima,
    super.horasAnticipacionLluvia,
  });

  factory PrediccionModel.fromJson(Map<String, dynamic> json) {
    return PrediccionModel(
      idPrediccion: json['id_prediccion'] as int? ?? 0,
      loteId: json['lote_id'] as int? ?? 0,
      tiempoEstimadoHoras:
          (json['tiempo_estimado_horas'] as num?)?.toDouble() ?? 0.0,
      // Puntaje escala SCA 0-100 (num en el JSON desde la migración; antes era un String tipo
      // "buena"). (as num?) tolera que el backend mande int o double indistintamente.
      calidadEstimada: (json['calidad_estimada'] as num?)?.toDouble(),
      confianza: (json['confianza'] as num?)?.toDouble() ?? 0.0,
      fechaPrediccion: json['fecha_prediccion'] as String?,
      modeloVersion: json['modelo_version'] as String?,
      // Salida del AG de riesgo de lluvia (Go: internal/domain/entities.Prediccion). Null si
      // ese predictor no llegó a correr para esta predicción.
      riesgoLluviaProxima: json['riesgo_lluvia_proxima'] as bool?,
      horasAnticipacionLluvia: json['horas_anticipacion_lluvia'] as int?,
    );
  }
}
