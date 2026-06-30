import 'package:flutter/material.dart';

import '../../data/models/sensor_model.dart';
import '../widgets/sensor_info_card.dart';

class SensorDetailPage extends StatelessWidget {

  final SensorModel sensor;

  const SensorDetailPage({
    super.key,
    required this.sensor,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Detalle del Sensor"),
        centerTitle: true,
      ),

      body: SingleChildScrollView(

        padding: const EdgeInsets.all(16),

        child: Column(

          crossAxisAlignment: CrossAxisAlignment.stretch,

          children: [

            SensorInfoCard(
              sensor: sensor,
            ),

            const SizedBox(height: 25),

            FilledButton.icon(

              icon: const Icon(Icons.edit),

              label: const Text("Editar Sensor"),

              onPressed: () {

                ScaffoldMessenger.of(context).showSnackBar(

                  const SnackBar(
                    content: Text(
                      "Función disponible próximamente.",
                    ),
                  ),

                );

              },

            ),

            const SizedBox(height: 15),

            FilledButton.icon(

              style: FilledButton.styleFrom(
                backgroundColor: Colors.red,
              ),

              icon: const Icon(Icons.delete),

              label: const Text("Eliminar Sensor"),

              onPressed: () {

                ScaffoldMessenger.of(context).showSnackBar(

                  const SnackBar(
                    content: Text(
                      "Sensor eliminado (simulado).",
                    ),
                  ),

                );

              },

            ),

          ],
        ),
      ),
    );
  }
}