//lib/features/monitoring/presentation/widgets/environment_card.dart
import 'package:flutter/material.dart';

import '../../domain/entities/estadisticas_entity.dart';

class EnvironmentCard extends StatelessWidget {
  final EstadisticasEntity estadisticas;

  const EnvironmentCard({
    super.key,
    required this.estadisticas,
  });

  // Antes esto era un ListTile con leading + title + trailing: con un
  // CircleAvatar ancho y un título largo ("Temperatura (min / prom / max)")
  // compitiendo por el mismo ancho de fila que el valor ("22.5 / 25.0 / 30.1
  // °C"), ListTile le dejaba al title un ancho casi nulo -- el texto se
  // envolvía letra por letra (vertical). Ahora todo va en una Column: el
  // título arriba, el valor abajo, cada uno usando el ancho completo de la
  // tarjeta.
  Widget _sensorTile({
    required IconData icon,
    required String titulo,
    required String valor,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withValues(alpha: 0.15),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    valor,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),

      child: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              "Condiciones Ambientales",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            _sensorTile(
              icon: Icons.thermostat,
              titulo: "Temperatura (min / prom / max)",
              valor: "${estadisticas.temperaturaMin.toStringAsFixed(1)} / "
                  "${estadisticas.temperaturaPromedio.toStringAsFixed(1)} / "
                  "${estadisticas.temperaturaMax.toStringAsFixed(1)} °C",
              color: Colors.red,
            ),

            const SizedBox(height: 10),

            _sensorTile(
              icon: Icons.water_drop,
              titulo: "Humedad (min / prom / max)",
              valor: "${estadisticas.humedadMin.toStringAsFixed(1)} / "
                  "${estadisticas.humedadPromedio.toStringAsFixed(1)} / "
                  "${estadisticas.humedadMax.toStringAsFixed(1)} %",
              color: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
}
