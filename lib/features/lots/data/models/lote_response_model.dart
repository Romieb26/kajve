import '../../domain/entities/lote_entity.dart';

/// Respuesta de POST /lotes. Solo se modela codigo_qr (obligatorio para
/// esta pantalla) e id_lote (opcional); el resto de campos que el
/// backend pueda devolver no se usan todavía en la UI.
class LoteResponseModel extends LoteEntity {
  const LoteResponseModel({
    required super.idLote,
    required super.codigoQr,
  });

  factory LoteResponseModel.fromJson(Map<String, dynamic> json) {
    return LoteResponseModel(
      idLote: json['id_lote'] as int?,
      codigoQr: json['codigo_qr'] as String,
    );
  }
}
