//lib/features/monitoring/data/models/estadisticas_model.dart
import '../../domain/entities/estadisticas_entity.dart';

class EstadisticasModel extends EstadisticasEntity {
  const EstadisticasModel({
    required super.temperaturaPromedio,
    required super.temperaturaMin,
    required super.temperaturaMax,
    required super.humedadPromedio,
    required super.humedadMin,
    required super.humedadMax,
    required super.totalLecturas,
    required super.totalAlertas,
    required super.alertasCriticas,
    required super.alertasSinAtender,
    required super.diasSecado,
    super.ultimaLectura,
  });

  factory EstadisticasModel.fromJson(Map<String, dynamic> json) {
    // AVG()/MIN()/MAX() en SQL devuelven NULL sobre un lote sin lecturas
    // todavía (mismo patrón que ya rompió el dashboard) — con ?? 0.0
    // evitamos que un lote recién creado truene el parseo.
    return EstadisticasModel(
      temperaturaPromedio:
          (json['temperatura_promedio'] as num?)?.toDouble() ?? 0.0,
      temperaturaMin: (json['temperatura_min'] as num?)?.toDouble() ?? 0.0,
      temperaturaMax: (json['temperatura_max'] as num?)?.toDouble() ?? 0.0,
      humedadPromedio: (json['humedad_promedio'] as num?)?.toDouble() ?? 0.0,
      humedadMin: (json['humedad_min'] as num?)?.toDouble() ?? 0.0,
      humedadMax: (json['humedad_max'] as num?)?.toDouble() ?? 0.0,
      totalLecturas: json['total_lecturas'] as int,
      totalAlertas: json['total_alertas'] as int,
      alertasCriticas: json['alertas_criticas'] as int,
      alertasSinAtender: json['alertas_sin_atender'] as int,
      diasSecado: json['dias_secado'] as int,
      ultimaLectura: json['ultima_lectura'] as String?,
    );
  }
}
