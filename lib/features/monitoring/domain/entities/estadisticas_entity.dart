//lib/features/monitoring/domain/entities/estadisticas_entity.dart
class EstadisticasEntity {
  final double temperaturaPromedio;
  final double temperaturaMin;
  final double temperaturaMax;
  final double humedadPromedio;
  final double humedadMin;
  final double humedadMax;
  final int totalLecturas;
  final int totalAlertas;
  final int alertasCriticas;
  final int alertasSinAtender;
  final int diasSecado;
  final String? ultimaLectura;

  const EstadisticasEntity({
    required this.temperaturaPromedio,
    required this.temperaturaMin,
    required this.temperaturaMax,
    required this.humedadPromedio,
    required this.humedadMin,
    required this.humedadMax,
    required this.totalLecturas,
    required this.totalAlertas,
    required this.alertasCriticas,
    required this.alertasSinAtender,
    required this.diasSecado,
    this.ultimaLectura,
  });
}
