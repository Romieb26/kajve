class PrediccionEntity {
  final int idPrediccion;
  final int loteId;
  final double tiempoEstimadoHoras;
  // Puntaje escala SCA 0-100 (protocolo de la Specialty Coffee Association) -- ya NO es una
  // categoría de texto tipo "buena". Null hasta que haya suficientes lotes reales para entrenar
  // el modelo (ver microservicioMLL: migration.sql paso 10 y ML/definicion_problema_kajve.md
  // Sección 3.3). Es una aproximación basada en condiciones de secado, no una catación real.
  final double? calidadEstimada;
  final double confianza;
  final String? fechaPrediccion;
  final String? modeloVersion;

  // Salida del algoritmo genético (AG) de riesgo de lluvia (microservicioMLL:
  // app/services/rain_predictor.py, entrenado con ML/prediccion_lluvia_ga.py). Ambos null
  // cuando el pipeline no llegó a correr ese predictor para esta predicción (p.ej. sin
  // lecturas de humedad/temperatura suficientes todavía).
  final bool? riesgoLluviaProxima;
  final int? horasAnticipacionLluvia;

  const PrediccionEntity({
    required this.idPrediccion,
    required this.loteId,
    required this.tiempoEstimadoHoras,
    required this.calidadEstimada,
    required this.confianza,
    this.fechaPrediccion,
    this.modeloVersion,
    this.riesgoLluviaProxima,
    this.horasAnticipacionLluvia,
  });
}
