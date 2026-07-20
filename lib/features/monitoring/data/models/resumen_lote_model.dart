//lib/features/monitoring/data/models/resumen_lote_model.dart
import '../../domain/entities/resumen_lote_entity.dart';

class ResumenLoteModel extends ResumenLoteEntity {
  const ResumenLoteModel({
    required super.totalLecturas,
    super.primeraLectura,
    super.ultimaLectura,
    super.temperaturaMin,
    super.temperaturaProm,
    super.temperaturaMax,
    super.temperaturaGranoMin,
    super.temperaturaGranoProm,
    super.temperaturaGranoMax,
    super.humedadGranoMin,
    super.humedadGranoProm,
    super.humedadGranoMax,
    super.presionHpaMin,
    super.presionHpaProm,
    super.presionHpaMax,
  });

  factory ResumenLoteModel.fromJson(Map<String, dynamic> json) {
    double? campo(String key) => (json[key] as num?)?.toDouble();
    DateTime? fecha(String key) =>
        DateTime.tryParse(json[key] as String? ?? '');

    return ResumenLoteModel(
      totalLecturas: json['total_lecturas'] as int? ?? 0,
      primeraLectura: fecha('primera_lectura'),
      ultimaLectura: fecha('ultima_lectura'),
      temperaturaMin: campo('temperatura_min'),
      temperaturaProm: campo('temperatura_prom'),
      temperaturaMax: campo('temperatura_max'),
      temperaturaGranoMin: campo('temperatura_grano_min'),
      temperaturaGranoProm: campo('temperatura_grano_prom'),
      temperaturaGranoMax: campo('temperatura_grano_max'),
      humedadGranoMin: campo('humedad_grano_min'),
      humedadGranoProm: campo('humedad_grano_prom'),
      humedadGranoMax: campo('humedad_grano_max'),
      presionHpaMin: campo('presion_hpa_min'),
      presionHpaProm: campo('presion_hpa_prom'),
      presionHpaMax: campo('presion_hpa_max'),
    );
  }
}
