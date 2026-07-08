class AlertaEntity {
  final int idAlerta;
  final int loteId;
  final String tipoAlerta;
  final String mensaje;
  final String nivelSeveridad;
  final bool atendida;
  final String? fechaAtencion;
  final String fechaGenerada;

  const AlertaEntity({
    required this.idAlerta,
    required this.loteId,
    required this.tipoAlerta,
    required this.mensaje,
    required this.nivelSeveridad,
    required this.atendida,
    this.fechaAtencion,
    required this.fechaGenerada,
  });
}
