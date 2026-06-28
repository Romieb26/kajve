class AlertModel {
  final String titulo;
  final String descripcion;
  final String fecha;
  final String nivel; // alta, media, baja

  AlertModel({
    required this.titulo,
    required this.descripcion,
    required this.fecha,
    required this.nivel,
  });
}