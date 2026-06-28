class HistoryModel {
  final String lote;
  final String fecha;
  final double temperatura;
  final double humedad;
  final String estado;

  HistoryModel({
    required this.lote,
    required this.fecha,
    required this.temperatura,
    required this.humedad,
    required this.estado,
  });
}