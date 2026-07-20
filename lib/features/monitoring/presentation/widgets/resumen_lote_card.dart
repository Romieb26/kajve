//lib/features/monitoring/presentation/widgets/resumen_lote_card.dart
import 'package:flutter/material.dart';

import '../../domain/entities/resumen_lote_entity.dart';

/// Resumen de TODO el lote (min/prom/max de todas sus lecturas), calculado
/// en ws-gateway — a diferencia de Tiempo Real (últimos ~60 puntos) y
/// Sensores (conectado/desconectado ahora mismo), esta tarjeta es la única
/// que responde "¿cómo va el lote completo desde que empezó?". No depende
/// de api-mobile, así que sigue funcionando aunque /estadisticas falle.
class ResumenLoteCard extends StatelessWidget {
  final ResumenLoteEntity? resumen;

  const ResumenLoteCard({super.key, required this.resumen});

  @override
  Widget build(BuildContext context) {
    final r = resumen;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Resumen del lote completo",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Divider(height: 30),

            if (r == null)
              const Text(
                "No se pudo cargar el resumen.",
                style: TextStyle(color: Colors.grey),
              )
            else if (r.sinLecturas)
              const Text(
                "Este lote todavía no tiene lecturas registradas.",
                style: TextStyle(color: Colors.grey),
              )
            else ...[
              _fila("Total de lecturas", "${r.totalLecturas}"),
              const SizedBox(height: 16),
              _rango(
                "Temperatura",
                Icons.thermostat,
                Colors.red,
                r.temperaturaMin,
                r.temperaturaProm,
                r.temperaturaMax,
                "°C",
              ),
              _rango(
                "Temp. del grano",
                Icons.grain,
                Colors.brown,
                r.temperaturaGranoMin,
                r.temperaturaGranoProm,
                r.temperaturaGranoMax,
                "°C",
              ),
              _rango(
                "Humedad del grano",
                Icons.grain,
                Colors.teal,
                r.humedadGranoMin,
                r.humedadGranoProm,
                r.humedadGranoMax,
                "",
              ),
              _rango(
                "Presión",
                Icons.speed,
                Colors.deepPurple,
                r.presionHpaMin,
                r.presionHpaProm,
                r.presionHpaMax,
                "hPa",
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _fila(String titulo, String valor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(titulo),
          Text(valor, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _rango(
    String titulo,
    IconData icono,
    Color color,
    double? min,
    double? prom,
    double? max,
    String unidad,
  ) {
    if (min == null && prom == null && max == null) {
      return const SizedBox.shrink();
    }
    final sufijo = unidad.isEmpty ? '' : ' $unidad';
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withValues(alpha: 0.15),
            child: Icon(icono, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(titulo, style: const TextStyle(fontSize: 13)),
                Text(
                  "${min?.toStringAsFixed(1) ?? '—'} / "
                  "${prom?.toStringAsFixed(1) ?? '—'} / "
                  "${max?.toStringAsFixed(1) ?? '—'}$sufijo",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
