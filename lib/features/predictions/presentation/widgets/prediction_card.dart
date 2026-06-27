import 'package:flutter/material.dart';

import '../providers/prediction_provider.dart';

class PredictionCard extends StatelessWidget {
  final PredictionProvider provider;

  const PredictionCard({
    super.key,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
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
              "Predicción del Secado",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: 150,
              height: 150,
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
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const Text("Completado"),

                    ],
                  )

                ],
              ),
            ),

            const SizedBox(height: 20),

            Chip(
              avatar: const Icon(
                Icons.check_circle,
                color: Colors.green,
              ),
              label: Text(provider.estado),
            ),

          ],
        ),
      ),
    );
  }
}