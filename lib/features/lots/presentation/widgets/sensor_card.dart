import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/lot_provider.dart';

class SensorCard extends StatelessWidget {
  const SensorCard({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LotProvider>(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Asociar sensores",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 15),

          TextField(
            controller: provider.sensorIdController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: "ID de sensor (opcional)",
              helperText:
                  "Déjalo vacío si el lote no tiene sensor asignado.",
              prefixIcon: Icon(Icons.sensors),
              border: UnderlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }
}
