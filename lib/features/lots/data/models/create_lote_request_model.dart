class CreateLoteRequestModel {
  final String nombreLote;
  final String variedad;
  final String tipoProceso;
  final double pesoKg;
  final String ubicacion;
  final int? idSensor;

  const CreateLoteRequestModel({
    required this.nombreLote,
    required this.variedad,
    required this.tipoProceso,
    required this.pesoKg,
    required this.ubicacion,
    required this.idSensor,
  });

  Map<String, dynamic> toJson() {
    return {
      'nombre_lote': nombreLote,
      'variedad': variedad,
      'tipo_proceso': tipoProceso,
      'peso_kg': pesoKg,
      'ubicacion': ubicacion,
      'id_sensor': idSensor,
    };
  }
}
