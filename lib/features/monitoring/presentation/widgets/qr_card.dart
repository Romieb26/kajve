//lib/features/monitoring/presentation/widgets/qr_card.dart
import 'package:flutter/material.dart';

class QrCard extends StatelessWidget {
  const QrCard({super.key});

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
          children: [

            const Text(
              "Código QR del lote",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Container(
              width: 180,
              height: 180,

              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(15),
              ),

              child: const Center(
                child: Icon(
                  Icons.qr_code_2,
                  size: 120,
                ),
              ),
            ),

            const SizedBox(height: 15),

            FilledButton.icon(
              onPressed: () {
                // TODO: Descargar o compartir QR
              },
              icon: const Icon(Icons.download),
              label: const Text("Descargar QR"),
            ),

          ],
        ),
      ),
    );
  }
}