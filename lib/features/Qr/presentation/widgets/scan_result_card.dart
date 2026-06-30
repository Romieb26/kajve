import 'package:flutter/material.dart';

import '../providers/qr_provider.dart';

class ScanResultCard extends StatelessWidget {
  final QrProvider provider;

  const ScanResultCard({
    super.key,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    if (provider.ultimoCodigo == null) {
      return const SizedBox();
    }

    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 70,
            ),

            const SizedBox(height: 15),

            const Text(
              "Código QR detectado",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.brown.shade50,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  const Text(
                    "Contenido del QR",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  SelectableText(
                    provider.ultimoCodigo!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Próximamente se mostrará la información del lote.",
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.visibility),
                label: const Text("Ver información"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}