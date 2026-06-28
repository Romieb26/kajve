import 'package:flutter/material.dart';

import '../providers/monitoring_provider.dart';

class EnvironmentCard extends StatelessWidget {
  final MonitoringProvider provider;

  const EnvironmentCard({
    super.key,
    required this.provider,
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
          backgroundColor: color.withOpacity(0.15),
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
              titulo: "Temperatura",
              valor: "${provider.temperatura} °C",
              color: Colors.red,
            ),

            _sensorTile(
              icon: Icons.water_drop,
              titulo: "Humedad",
              valor: "${provider.humedad} %",
              color: Colors.blue,
            ),

            _sensorTile(
              icon: Icons.wb_sunny,
              titulo: "Radiación Solar",
              valor: "${provider.radiacion} W/m²",
              color: Colors.orange,
            ),

            _sensorTile(
              icon: Icons.air,
              titulo: "Velocidad del viento",
              valor: "${provider.viento} km/h",
              color: Colors.green,
            ),
          ],
        ),
      ),
    );
  }
}