import 'package:flutter/material.dart';

import '../../data/models/sensor_model.dart';

class SensorCard extends StatelessWidget {
  final SensorModel sensor;

  const SensorCard({
    super.key,
    required this.sensor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [

            CircleAvatar(
              radius: 28,
              backgroundColor: sensor.colorEstado.withOpacity(.15),
              child: Icon(
                Icons.sensors,
                color: sensor.colorEstado,
              ),
            ),

            const SizedBox(width: 15),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    sensor.nombre,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text("Tipo: ${sensor.tipo}"),

                  Text("Código: ${sensor.codigo}"),

                  Text("Lote: ${sensor.lote}"),

                ],
              ),
            ),

            Chip(
              label: Text(sensor.estado),
              backgroundColor:
              sensor.colorEstado.withOpacity(.2),
            )

          ],
        ),
      ),
    );
  }
}