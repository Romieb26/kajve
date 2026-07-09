import '../../domain/entities/historial_evento_entity.dart';

class HistorialEventoModel extends HistorialEventoEntity {
  const HistorialEventoModel({
    required super.idEvento,
    required super.loteId,
    required super.tipoEvento,
    required super.descripcion,
    required super.fechaEvento,
  });

  factory HistorialEventoModel.fromJson(Map<String, dynamic> json) {
    return HistorialEventoModel(
      idEvento: json['id_evento'] as int,
      loteId: json['lote_id'] as int,
      tipoEvento: json['tipo_evento'] as String? ?? '',
      descripcion: json['descripcion'] as String? ?? '',
      fechaEvento: json['fecha_evento'] as String? ?? '',
    );
  }
}
