class LecturaEntity {
  final int? idLectura;
  final int? idLote;
  final int? idSensor;
  final double temperatura;
  final double humedad;
  final double? presion;
  final String? timestamp;

  const LecturaEntity({
    this.idLectura,
    this.idLote,
    this.idSensor,
    required this.temperatura,
    required this.humedad,
    this.presion,
    this.timestamp,
  });
}
