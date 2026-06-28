import 'package:flutter/material.dart';

import '../providers/prediction_provider.dart';

class PredictionCard extends StatelessWidget {
  final PredictionProvider provider;

  const PredictionCard({
    super.key,
    required this.provider,
  });

  Color getStatusColor() {
    switch (provider.estado.toLowerCase()) {
      case "óptimo":
        return Colors.green;

      case "en proceso":
        return Colors.orange;

      case "riesgo":
        return Colors.red;

      default:
        return Colors.blueGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = getStatusColor();

    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            const Text(
              "Predicción IA",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: 170,
              height: 170,
              child: Stack(
                alignment: Alignment.center,
                children: [

                  CircularProgressIndicator(
                    value: provider.porcentajeSecado / 100,
                    strokeWidth: 12,
                  ),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      Text(
                        "${provider.porcentajeSecado.toInt()}%",
                        style: const TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const Text("Secado"),

                    ],
                  )

                ],
              ),
            ),

            const SizedBox(height: 20),

            Chip(
              avatar: Icon(
                Icons.check_circle,
                color: color,
              ),
              label: Text(provider.estado),
            ),

            const SizedBox(height: 15),

            Text(
              "Confianza IA: ${provider.confianza}%",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}