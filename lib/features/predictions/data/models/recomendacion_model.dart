import '../../domain/entities/recomendacion_entity.dart';

class RecomendacionModel extends RecomendacionEntity {
  const RecomendacionModel({
    required super.idRecomendacion,
    required super.idLote,
    required super.texto,
    super.origen,
    super.fechaGenerada,
  });

  factory RecomendacionModel.fromJson(Map<String, dynamic> json) {
    return RecomendacionModel(
      idRecomendacion: json['id_recomendacion'] as int? ?? 0,
      idLote: json['id_lote'] as int? ?? 0,
      texto: json['texto'] as String? ?? '',
      origen: json['origen'] as String?,
      fechaGenerada: json['fecha_generada'] as String?,
    );
  }
}
