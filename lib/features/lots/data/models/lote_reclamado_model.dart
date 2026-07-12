import '../../domain/entities/lote_reclamado_entity.dart';

/// Respuesta de PUT /lotes/reclamar.
class LoteReclamadoModel extends LoteReclamadoEntity {
  const LoteReclamadoModel({
    required super.idLote,
    required super.usuarioId,
    required super.nombreLote,
    required super.variedad,
    required super.tipoProceso,
    required super.pesoKg,
    required super.ubicacion,
    required super.idSensor,
    required super.codigoQr,
    required super.estado,
    required super.fechaInicioSecado,
    required super.fechaFinSecado,
    required super.linkedAt,
    required super.createdAt,
  });

  factory LoteReclamadoModel.fromJson(Map<String, dynamic> json) {
    return LoteReclamadoModel(
      idLote: json['id'] as int,
      usuarioId: json['usuario_id'] as int,
      nombreLote: json['nombre_lote'] as String? ?? '',
      variedad: json['variedad'] as String?,
      tipoProceso: json['tipo_proceso'] as String?,
      pesoKg: (json['peso_kg'] as num?)?.toDouble(),
      ubicacion: json['ubicacion'] as String?,
      idSensor: json['id_sensor'] as int?,
      codigoQr: json['codigo_qr'] as String? ?? '',
      estado: json['estado'] as String? ?? '',
      fechaInicioSecado: json['fecha_inicio_secado'] != null
          ? DateTime.tryParse(json['fecha_inicio_secado'] as String)
          : null,
      fechaFinSecado: json['fecha_fin_secado'] != null
          ? DateTime.tryParse(json['fecha_fin_secado'] as String)
          : null,
      linkedAt: json['linked_at'] != null
          ? DateTime.tryParse(json['linked_at'] as String)
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
    );
  }
}
