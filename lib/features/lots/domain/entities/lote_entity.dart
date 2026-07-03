// Entidad de dominio del lote creado, sin dependencias de Flutter ni JSON.
class LoteEntity {
  final int? idLote;
  final String codigoQr;

  const LoteEntity({
    required this.idLote,
    required this.codigoQr,
  });
}
