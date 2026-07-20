//lib/features/monitoring/data/models/lectura_model.dart
import '../../domain/entities/lectura_entity.dart';

class LecturaModel extends LecturaEntity {
  const LecturaModel({
    super.idLectura,
    super.idLote,
    super.idSensor,
    required super.temperatura,
    required super.humedad,
    super.presion,
    super.timestamp,
  });

  factory LecturaModel.fromJson(Map<String, dynamic> json) {
    return LecturaModel(
      idLectura: json['id_lectura'] as int?,
      idLote: json['lote_id'] as int?,
      idSensor: json['sensor_id'] as int?,
      temperatura: (json['temperatura'] as num).toDouble(),
      humedad: (json['humedad'] as num).toDouble(),
      presion: (json['presion'] as num?)?.toDouble(),
      timestamp: json['timestamp'] as String?,
    );
  }
}
