import 'package:flutter/material.dart';

import '../providers/prediction_provider.dart';

class PredictionHistory extends StatelessWidget {
  final PredictionProvider provider;

  const PredictionHistory({
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
              "Historial de Predicciones",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const Divider(),

            ...provider.historial.map(
                  (dato) => ListTile(

                leading: const Icon(Icons.history),

                title: Text(
                  "${dato["avance"]}% de secado",
                ),

                subtitle: Text(
                  dato["fecha"],
                ),

                trailing: const Icon(Icons.arrow_forward_ios),
              ),
            ),

          ],
        ),
      ),
    );
  }
}