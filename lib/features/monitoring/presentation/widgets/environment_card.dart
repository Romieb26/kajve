//lib/features/monitoring/presentation/widgets/environment_card.dart
import 'package:flutter/material.dart';

import '../../domain/entities/estadisticas_entity.dart';

class EnvironmentCard extends StatelessWidget {
  final EstadisticasEntity estadisticas;

  const EnvironmentCard({
    super.key,
    required this.estadisticas,
  });

  Widget _sensorTile({
    required IconData icon,
    required String titulo,
    required String valor,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.15),
          child: Icon(
            icon,
            color: color,
          ),
        ),
        title: Text(titulo),
        trailing: Text(
          valor,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
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
