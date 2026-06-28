import 'package:flutter/material.dart';

import '../providers/prediction_provider.dart';

class PredictionChart extends StatelessWidget {
  final PredictionProvider provider;

  const PredictionChart({
    super.key,
    required this.provider,
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

            const Text(
              "Avance del Secado",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            ...provider.historial.map((dato) {

              final porcentaje = dato["avance"] as int;

              return Padding(
                padding: const EdgeInsets.only(bottom: 16),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      children: [

                        Text(dato["fecha"]),

                        Text("$porcentaje %"),

                      ],
                    ),

                    const SizedBox(height: 6),

                    LinearProgressIndicator(
                      value: porcentaje / 100,
                      minHeight: 10,
                      borderRadius: BorderRadius.circular(20),
                    ),

                  ],
                ),
              );
            }),

          ],
        ),
      ),
    );
  }
}