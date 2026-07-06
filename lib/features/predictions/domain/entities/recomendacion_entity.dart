class RecomendacionEntity {
  final int idRecomendacion;
  final int idLote;
  final String texto;
  final String? origen;
  final String? fechaGenerada;

  const RecomendacionEntity({
    required this.idRecomendacion,
    required this.idLote,
    required this.texto,
    this.origen,
    this.fechaGenerada,
  });
}
