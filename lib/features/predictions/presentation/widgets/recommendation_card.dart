import 'package:flutter/material.dart';

import '../providers/prediction_provider.dart';

class RecommendationCard extends StatelessWidget {
  final PredictionProvider provider;

  const RecommendationCard({
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

            const Row(
              children: [

                Icon(
                  Icons.psychology,
                  color: Colors.deepPurple,
                ),

                SizedBox(width: 10),

                Text(
                  "Recomendaciones IA",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

              ],
            ),

            const SizedBox(height: 20),

            ...provider.recomendaciones.map(
                  (texto) => Padding(
                padding: const EdgeInsets.only(bottom: 12),

                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [

                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: Text(texto),
                    ),

                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}