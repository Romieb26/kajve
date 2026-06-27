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

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),

      child: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            const Text(
              "Recomendaciones",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            ...provider.recomendaciones.map(

                  (texto) => Padding(
                padding: const EdgeInsets.only(bottom: 10),

                child: Row(

                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [

                    const Icon(
                      Icons.check_circle_outline,
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