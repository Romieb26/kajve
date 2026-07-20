//lib/features/realtime/data/models/lectura_tiempo_real_model.dart
import '../../domain/entities/lectura_tiempo_real_entity.dart';

class LecturaTiempoRealModel extends LecturaTiempoRealEntity {
  const LecturaTiempoRealModel({
    required super.sensorId,
    required super.timestamp,
    super.temperatura,
    super.temperaturaGrano,
    super.luz,
    super.lluviaAnalog,
    super.lluviaDetectada,
    super.humedadGrano,
    super.presionHpa,
    super.altitudM,
    super.estadoSensores,
  });

  /// Sirve tanto para un "punto" del histórico inicial
  /// (`{"sensor_id","timestamp","lectura":{...}}`) como para un evento en
  /// vivo (`{"tipo","lote_id","sensor_id","lectura":{...},"timestamp"}`):
  /// ambos comparten la misma forma de sensor_id/timestamp/lectura en el
  /// nivel raíz del objeto, así que un solo parser sirve para los dos
  /// (ver ws-gateway: domain/entities.PuntoHistorico y
  /// ingesta-iot: domain/entities.RealtimeEvent).
  factory LecturaTiempoRealModel.fromJson(Map<String, dynamic> json) {
    final lectura = json['lectura'] as Map<String, dynamic>? ?? const {};
    double? campo(String key) => (lectura[key] as num?)?.toDouble();

    return LecturaTiempoRealModel(
      sensorId: json['sensor_id'] as int? ?? 0,
      timestamp: DateTime.tryParse(json['timestamp'] as String? ?? '') ??
          DateTime.now(),
      temperatura: campo('temperatura'),
      temperaturaGrano: campo('temperatura_grano'),
      luz: campo('luz'),
      lluviaAnalog: campo('lluvia_analog'),
      lluviaDetectada: lectura['lluvia_detectada'] as bool?,
      humedadGrano: campo('humedad_grano'),
      presionHpa: campo('presion_hpa'),
      altitudM: campo('altitud_m'),
      estadoSensores: _parseEstadoSensores(
        lectura['estado_sensores'] as Map<String, dynamic>?,
      ),
    );
  }

  static EstadoSensoresLive? _parseEstadoSensores(Map<String, dynamic>? json) {
    if (json == null) return null;
    return EstadoSensoresLive(
      bmp280: json['bmp280'] as bool?,
      ds18b20: json['ds18b20'] as bool?,
      bh1750: json['bh1750'] as bool?,
      fc37: json['fc37'] as bool?,
      humedadSuelo: json['humedad_suelo'] as bool?,
    );
  }
}
