/// Entidad de dominio de un lote listado, sin dependencias de Flutter ni JSON.
class LotEntity {
  final int idLote;
  final String nombreLote;
  final String variedad;
  final String tipoProceso;
  final double pesoKg;
  final String ubicacion;
  final int? idSensor;
  final String codigoQr;
  final String estado;
  final DateTime? fechaInicioSecado;
  final DateTime? fechaFinSecado;
  final DateTime? createdAt;

  const LotEntity({
    required this.idLote,
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
    required this.createdAt,
  });
}
