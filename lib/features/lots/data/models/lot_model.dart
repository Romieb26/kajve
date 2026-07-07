import '../../domain/entities/lot.dart';

/// Respuesta de un elemento de GET /lotes (LoteListItem en el backend).
class LotModel extends LotEntity {
  const LotModel({
    required super.idLote,
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
    required super.createdAt,
  });

  factory LotModel.fromJson(Map<String, dynamic> json) {
    return LotModel(
      idLote: json['id'] as int,
      nombreLote: json['nombre_lote'] as String? ?? '',
      variedad: json['variedad'] as String? ?? '',
      tipoProceso: json['tipo_proceso'] as String? ?? '',
      pesoKg: (json['peso_kg'] as num?)?.toDouble() ?? 0.0,
      ubicacion: json['ubicacion'] as String? ?? '',
      idSensor: json['id_sensor'] as int?,
      codigoQr: json['codigo_qr'] as String? ?? '',
      estado: json['estado'] as String? ?? '',
      fechaInicioSecado: json['fecha_inicio_secado'] != null
          ? DateTime.tryParse(json['fecha_inicio_secado'] as String)
          : null,
      fechaFinSecado: json['fecha_fin_secado'] != null
          ? DateTime.tryParse(json['fecha_fin_secado'] as String)
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
    );
  }
}
