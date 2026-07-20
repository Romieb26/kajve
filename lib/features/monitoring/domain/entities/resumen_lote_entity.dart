//lib/features/monitoring/domain/entities/resumen_lote_entity.dart

/// Agregados (min/promedio/max) sobre TODAS las lecturas guardadas de un
/// lote, calculados directo en ws-gateway/Postgres (GET /lotes/{id}/resumen)
/// — a diferencia de Tiempo Real (últimos ~60 puntos, vía WebSocket) y
/// Sensores (conectado/desconectado del hardware ahora mismo), esta es la
/// única vista que responde "¿cómo va el lote completo desde que empezó?".
/// No depende de api-mobile.
class ResumenLoteEntity {
  final int totalLecturas;
  final DateTime? primeraLectura;
  final DateTime? ultimaLectura;

  final double? temperaturaMin;
  final double? temperaturaProm;
  final double? temperaturaMax;

  final double? temperaturaGranoMin;
  final double? temperaturaGranoProm;
  final double? temperaturaGranoMax;

  final double? humedadGranoMin;
  final double? humedadGranoProm;
  final double? humedadGranoMax;

  final double? presionHpaMin;
  final double? presionHpaProm;
  final double? presionHpaMax;

  const ResumenLoteEntity({
    required this.totalLecturas,
    this.primeraLectura,
    this.ultimaLectura,
    this.temperaturaMin,
    this.temperaturaProm,
    this.temperaturaMax,
    this.temperaturaGranoMin,
    this.temperaturaGranoProm,
    this.temperaturaGranoMax,
    this.humedadGranoMin,
    this.humedadGranoProm,
    this.humedadGranoMax,
    this.presionHpaMin,
    this.presionHpaProm,
    this.presionHpaMax,
  });

  /// true si el lote todavía no tiene ninguna lectura guardada — para
  /// mostrar un mensaje distinto de "0.0 / 0.0 / 0.0" en la UI.
  bool get sinLecturas => totalLecturas == 0;
}
