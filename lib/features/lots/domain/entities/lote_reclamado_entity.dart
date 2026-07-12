/// Entidad de dominio del lote devuelto por PUT /lotes/reclamar.
/// A diferencia de [LotEntity] (GET /lotes), aquí variedad, tipo_proceso,
/// peso_kg y ubicacion pueden venir null: el lote lo pre-crea un admin
/// desde api-web con datos mínimos, y el productor los completa después.
class LoteReclamadoEntity {
  final int idLote;
  final int usuarioId;
  final String nombreLote;
  final String? variedad;
  final String? tipoProceso;
  final double? pesoKg;
  final String? ubicacion;
  final int? idSensor;
  final String codigoQr;
  final String estado;
  final DateTime? fechaInicioSecado;
  final DateTime? fechaFinSecado;
  final DateTime? linkedAt;
  final DateTime? createdAt;

  const LoteReclamadoEntity({
    required this.idLote,
    required this.usuarioId,
    required this.nombreLote,
    required this.variedad,
    required this.tipoProceso,
    required this.pesoKg,
    required this.ubicacion,
    required this.idSensor,
    required this.codigoQr,
    required this.estado,
    required this.fechaInicioSecado,
    required this.fechaFinSecado,
    required this.linkedAt,
    required this.createdAt,
  });
}
