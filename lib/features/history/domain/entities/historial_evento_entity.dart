class HistorialEventoEntity {
  final int idEvento;
  final int loteId;
  final String tipoEvento;
  final String descripcion;
  final String fechaEvento;

  const HistorialEventoEntity({
    required this.idEvento,
    required this.loteId,
    required this.tipoEvento,
    required this.descripcion,
    required this.fechaEvento,
  });
}
