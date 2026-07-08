import '../../domain/entities/alerta_entity.dart';

class AlertaModel extends AlertaEntity {
  const AlertaModel({
    required super.idAlerta,
    required super.loteId,
    required super.tipoAlerta,
    required super.mensaje,
    required super.nivelSeveridad,
    required super.atendida,
    super.fechaAtencion,
    required super.fechaGenerada,
  });

  factory AlertaModel.fromJson(Map<String, dynamic> json) {
    return AlertaModel(
      idAlerta: json['id_alerta'] as int,
      loteId: json['lote_id'] as int,
      tipoAlerta: json['tipo_alerta'] as String? ?? '',
      mensaje: json['mensaje'] as String? ?? '',
      nivelSeveridad: json['nivel_severidad'] as String? ?? '',
      atendida: json['atendida'] as bool? ?? false,
      fechaAtencion: json['fecha_atencion'] as String?,
      fechaGenerada: json['fecha_generada'] as String? ?? '',
    );
  }
}
