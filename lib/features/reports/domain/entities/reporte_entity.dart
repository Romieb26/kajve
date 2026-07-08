class ReporteEntity {
  final int id;
  final int idLote;
  final int idUsuario;
  final String tipoReporte;
  final String formato;
  final String? urlArchivo;
  final String fechaGeneracion;

  const ReporteEntity({
    required this.id,
    required this.idLote,
    required this.idUsuario,
    required this.tipoReporte,
    required this.formato,
    this.urlArchivo,
    required this.fechaGeneracion,
  });
}
