//libs/features/sensors/data/models/estado_sensor_model.dart
import 'sensor_model.dart';

/// Convierte una entrada de la respuesta de `GET /sensores/estado` de
/// ws-gateway
/// (`{"sensor_id","mac_address","tipo","lote_id","nombre_lote","conectado","ultima_lectura"}`)
/// en el SensorModel que ya consume la UI existente (SensorCard,
/// SensorInfoCard, etc.), para no tener que tocar esos widgets.
class EstadoSensorModel {
  static SensorModel fromJson(Map<String, dynamic> json) {
    final macAddress = json['mac_address'] as String? ?? '';
    final tipoCrudo = json['tipo'] as String? ?? '';

    return SensorModel(
      sensorId: json['sensor_id'] as int?,
      nombre: macAddress.isEmpty ? "Sensor" : "Sensor $macAddress",
      tipo: _tipoLegible(tipoCrudo),
      codigo: macAddress,
      lote: json['nombre_lote'] as String? ?? '',
      conectado: json['conectado'] as bool? ?? false,
      loteId: json['lote_id'] as int?,
    );
  }

  static String _tipoLegible(String tipo) {
    switch (tipo) {
      case 'temperatura':
        return 'Temperatura';
      case 'humedad':
        return 'Humedad';
      case 'ambos':
        return 'Temperatura y humedad';
      default:
        return tipo.isEmpty ? '—' : tipo;
    }
  }
}
