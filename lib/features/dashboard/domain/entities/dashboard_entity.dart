// Entidades de dominio del dashboard, sin dependencias de Flutter ni JSON.

class UltimaPrediccionEntity {
  final int idLote;
  final String nombreLote;
  final double tiempoEstimadoHoras;
  final String calidadEstimada;
  final DateTime fechaPrediccion;

  const UltimaPrediccionEntity({
    required this.idLote,
    required this.nombreLote,
    required this.tiempoEstimadoHoras,
    required this.calidadEstimada,
    required this.fechaPrediccion,
  });
}

class LoteResumenEntity {
  final int idLote;
  final String nombreLote;
  final String estado;
  final int diasSecado;
  // Nulos cuando el lote todavía no tiene lecturas de sensor asociadas.
  final double? ultimaTemperatura;
  final double? ultimaHumedad;
  final int alertasActivas;

  const LoteResumenEntity({
    required this.idLote,
    required this.nombreLote,
    required this.estado,
    required this.diasSecado,
    required this.ultimaTemperatura,
    required this.ultimaHumedad,
    required this.alertasActivas,
  });
}

class DashboardEntity {
  final int totalLotes;
  final int lotesActivos;
  final int lotesFinalizados;
  final int alertasSinAtender;
  final int alertasCriticasActivas;
  // Nulos cuando aún no hay lecturas de sensores para promediar
  // (mismo caso que ultima_temperatura/ultima_humedad por lote).
  final double? temperaturaPromedioActual;
  final double? humedadPromedioActual;
  final int totalReportes;
  final int totalSensores;
  final UltimaPrediccionEntity? ultimaPrediccion;
  final List<LoteResumenEntity> lotesResumen;

  const DashboardEntity({
    required this.totalLotes,
    required this.lotesActivos,
    required this.lotesFinalizados,
    required this.alertasSinAtender,
    required this.alertasCriticasActivas,
    required this.temperaturaPromedioActual,
    required this.humedadPromedioActual,
    required this.totalReportes,
    required this.totalSensores,
    required this.ultimaPrediccion,
    required this.lotesResumen,
  });
}
