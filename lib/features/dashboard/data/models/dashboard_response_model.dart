import '../../domain/entities/dashboard_entity.dart';

class UltimaPrediccionModel extends UltimaPrediccionEntity {
  const UltimaPrediccionModel({
    required super.idLote,
    required super.nombreLote,
    required super.tiempoEstimadoHoras,
    required super.calidadEstimada,
    required super.fechaPrediccion,
  });

  factory UltimaPrediccionModel.fromJson(Map<String, dynamic> json) {
    return UltimaPrediccionModel(
      idLote: json['id_lote'] as int,
      nombreLote: json['nombre_lote'] as String,
      tiempoEstimadoHoras: (json['tiempo_estimado_horas'] as num?)?.toDouble(),
      calidadEstimada: json['calidad_estimada'] as String?,
      fechaPrediccion: DateTime.parse(json['fecha_prediccion'] as String),
    );
  }
}

class LoteResumenModel extends LoteResumenEntity {
  const LoteResumenModel({
    required super.idLote,
    required super.nombreLote,
    required super.estado,
    required super.diasSecado,
    required super.ultimaTemperatura,
    required super.ultimaHumedad,
    required super.alertasActivas,
  });

  factory LoteResumenModel.fromJson(Map<String, dynamic> json) {
    return LoteResumenModel(
      idLote: json['id_lote'] as int,
      nombreLote: json['nombre_lote'] as String,
      estado: json['estado'] as String,
      diasSecado: json['dias_secado'] as int,
      ultimaTemperatura: (json['ultima_temperatura'] as num?)?.toDouble(),
      ultimaHumedad: (json['ultima_humedad'] as num?)?.toDouble(),
      alertasActivas: json['alertas_activas'] as int,
    );
  }
}

/// Respuesta de GET /dashboard.
class DashboardResponseModel extends DashboardEntity {
  const DashboardResponseModel({
    required super.totalLotes,
    required super.lotesActivos,
    required super.lotesFinalizados,
    required super.alertasSinAtender,
    required super.alertasCriticasActivas,
    required super.temperaturaPromedioActual,
    required super.humedadPromedioActual,
    required super.totalReportes,
    required super.totalSensores,
    required super.ultimaPrediccion,
    required super.lotesResumen,
  });

  factory DashboardResponseModel.fromJson(Map<String, dynamic> json) {
    return DashboardResponseModel(
      totalLotes: json['total_lotes'] as int,
      lotesActivos: json['lotes_activos'] as int,
      lotesFinalizados: json['lotes_finalizados'] as int,
      alertasSinAtender: json['alertas_sin_atender'] as int,
      alertasCriticasActivas: json['alertas_criticas_activas'] as int,
      temperaturaPromedioActual:
          (json['temperatura_promedio_actual'] as num?)?.toDouble(),
      humedadPromedioActual:
          (json['humedad_promedio_actual'] as num?)?.toDouble(),
      totalReportes: json['total_reportes'] as int,
      totalSensores: json['total_sensores'] as int,
      // ultima_prediccion puede venir null si el usuario no tiene
      // predicciones todavía.
      ultimaPrediccion: json['ultima_prediccion'] != null
          ? UltimaPrediccionModel.fromJson(
              json['ultima_prediccion'] as Map<String, dynamic>,
            )
          : null,
      lotesResumen: (json['lotes_resumen'] as List<dynamic>? ?? [])
          .map((e) => LoteResumenModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
