class PrediccionEntity {
  final int idPrediccion;
  final int loteId;
  final double tiempoEstimadoHoras;
  final String calidadEstimada;
  final double confianza;
  final String? fechaPrediccion;
  final String? modeloVersion;

  const PrediccionEntity({
    required this.idPrediccion,
    required this.loteId,
    required this.tiempoEstimadoHoras,
    required this.calidadEstimada,
    required this.confianza,
    this.fechaPrediccion,
    this.modeloVersion,
  });
}
