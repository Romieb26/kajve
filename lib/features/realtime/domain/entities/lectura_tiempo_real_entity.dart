//lib/features/realtime/domain/entities/lectura_tiempo_real_entity.dart

/// Una lectura tal como llega por el WebSocket de ws-gateway, con TODAS
/// las variables que puede reportar el ESP32 (a diferencia de
/// LecturaEntity de monitoring, que solo trae temperatura/humedad/presion
/// porque viene del endpoint REST de api-mobile). Los campos son
/// nullable porque no todos los sensores miden todo (ver
/// sensores.mide_humedad_grano, etc. en el backend).
///
/// Alineado con la migración de BD / ingesta-iot / ws-gateway: ya no existe
/// "humedad" (humedad ambiente — el BMP280 no la mide y la columna se
/// eliminó). La vieja "lluvia" (normalizada 0-1) se reemplazó por
/// lluviaAnalog (lectura cruda del ADC del FC-37, 0-4095) y
/// lluviaDetectada (booleano). humedadGrano también llega como lectura
/// cruda del ADC (0-4095), no como porcentaje.
class LecturaTiempoRealEntity {
  final int sensorId;
  final DateTime timestamp;
  final double? temperatura;
  final double? temperaturaGrano;
  final double? luz;
  final double? lluviaAnalog;
  final bool? lluviaDetectada;
  final double? humedadGrano;
  final double? presionHpa;
  final double? altitudM;

  /// Estado real de cada sensor físico del ESP32, tal como lo reporta el
  /// propio firmware junto con la lectura (ver ingesta-iot/ws-gateway:
  /// EstadoSensores). Solo viene en lecturas EN VIVO — el histórico
  /// siempre lo trae null porque no se guarda en la base de datos.
  final EstadoSensoresLive? estadoSensores;

  const LecturaTiempoRealEntity({
    required this.sensorId,
    required this.timestamp,
    this.temperatura,
    this.temperaturaGrano,
    this.luz,
    this.lluviaAnalog,
    this.lluviaDetectada,
    this.humedadGrano,
    this.presionHpa,
    this.altitudM,
    this.estadoSensores,
  });
}

/// Estado on/off de cada sensor físico, tal como lo manda el ESP32.
/// bmp280/ds18b20/bh1750 se autodetectan (información confiable); fc37 y
/// humedad_suelo son analógicos puros y el firmware siempre los manda en
/// true (no hay forma de saber si siguen conectados), así que para esos
/// dos la UI sigue usando el heurístico de "valor pegado en 0" en vez de
/// confiar en este campo.
class EstadoSensoresLive {
  final bool? bmp280;
  final bool? ds18b20;
  final bool? bh1750;
  final bool? fc37;
  final bool? humedadSuelo;

  const EstadoSensoresLive({
    this.bmp280,
    this.ds18b20,
    this.bh1750,
    this.fc37,
    this.humedadSuelo,
  });

  /// Busca el estado por la misma clave que usa VariableConfig.sensorFisico
  /// ('bmp280', 'ds18b20', 'bh1750', 'fc37', 'humedad_suelo').
  bool? porClave(String clave) {
    switch (clave) {
      case 'bmp280':
        return bmp280;
      case 'ds18b20':
        return ds18b20;
      case 'bh1750':
        return bh1750;
      case 'fc37':
        return fc37;
      case 'humedad_suelo':
        return humedadSuelo;
      default:
        return null;
    }
  }
}
