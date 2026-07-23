/// Reporte en lenguaje natural (NLG, microservicioMLL: NLP/generar_reporte.py) de un lote --
/// combina alertas, predicciones y recomendaciones en un solo texto legible. Se genera al
/// momento en cada llamada (siempre refleja el estado actual del lote), no es un texto fijo
/// calculado una sola vez. Distinto de ReporteEntity (ese es el PDF/Excel de reportgen en Go).
class ReporteNarrativoEntity {
  final int idReporte;
  final int idLote;
  final String reporteTexto;
  final String fechaGenerado;

  const ReporteNarrativoEntity({
    required this.idReporte,
    required this.idLote,
    required this.reporteTexto,
    required this.fechaGenerado,
  });
}
