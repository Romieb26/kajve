import 'package:flutter/material.dart';

import '../../data/models/sensor_model.dart';
import 'sensor_status_chip.dart';

class SensorInfoCard extends StatelessWidget {

  final SensorModel sensor;

  const SensorInfoCard({
    super.key,
    required this.sensor,
  });

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

            const Center(
              child: Icon(
                Icons.sensors,
                size: 70,
                color: Colors.brown,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              sensor.nombre,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            Text("Tipo: ${sensor.tipo}"),

            const SizedBox(height: 8),

            Text("Código: ${sensor.codigo}"),

            const SizedBox(height: 8),

            Text("Lote asociado: ${sensor.lote}"),

            const SizedBox(height: 20),

            SensorStatusChip(
              conectado: sensor.conectado,
            ),

          ],
        ),
      ),
    );
  }
}