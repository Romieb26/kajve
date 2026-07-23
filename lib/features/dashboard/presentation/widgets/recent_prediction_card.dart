import 'package:flutter/material.dart';

class RecentPredictionCard extends StatelessWidget {
  final String lote;
  // Puntaje escala SCA 0-100 (protocolo de la Specialty Coffee Association). Null cuando el
  // modelo todavía no tiene suficientes lotes reales para estimar calidad -- ver
  // microservicioMLL: migration.sql paso 10 y ML/definicion_problema_kajve.md Sección 3.3.
  // Antes este widget recibía una categoría de texto (String estado) que en la práctica nunca
  // coincidía con ninguno de los casos de abajo (era una comparación contra 3 frases que el
  // backend jamás mandaba), así que siempre caía al color/icono por default.
  final double? puntajeCalidad;
  final String fecha;
  final VoidCallback onVer;

  const RecentPredictionCard({
    super.key,
    required this.lote,
    required this.puntajeCalidad,
    required this.fecha,
    required this.onVer,
  });

  String get _etiqueta {
    final puntaje = puntajeCalidad;
    if (puntaje == null) return "Aún sin datos suficientes";
    return "Calidad estimada: ${puntaje.toStringAsFixed(0)}/100 (SCA)";
  }

  Color _getStatusColor() {
    final puntaje = puntajeCalidad;
    if (puntaje == null) return Colors.blueGrey;
    if (puntaje >= 85) return Colors.green;
    if (puntaje >= 70) return Colors.orange;
    return Colors.red;
  }

  IconData _getStatusIcon() {
    final puntaje = puntajeCalidad;
    if (puntaje == null) return Icons.analytics;
    if (puntaje >= 85) return Icons.check_circle;
    if (puntaje >= 70) return Icons.water_drop;
    return Icons.thermostat;
  }

  @override
  Widget build(BuildContext context) {
    final color = _getStatusColor();

    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.15),
          child: Icon(
            _getStatusIcon(),
            color: color,
          ),
        ),
        title: Text(
          lote,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 4),

            Text(_etiqueta),

            const SizedBox(height: 2),

            Text(
              fecha,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),

          ],
        ),
        trailing: SizedBox(
          width: 70,
          child: FilledButton(
            style: FilledButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, 36),
            ),
            onPressed: onVer,
            child: const Text("Ver"),
          ),
        ),
        ),
    );
  }
}