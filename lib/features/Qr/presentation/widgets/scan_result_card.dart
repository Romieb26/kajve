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
    if (!provider.codigoEscaneado) {
      return const SizedBox();
    }

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
              "Información del QR",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const Divider(),

            ListTile(
              leading: const Icon(Icons.grass),
              title: const Text("Lote"),
              subtitle: Text(provider.lote),
            ),

            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Productor"),
              subtitle: Text(provider.productor),
            ),

            ListTile(
              leading: const Icon(Icons.analytics),
              title: const Text("Estado"),
              subtitle: Text(provider.estado),
            ),

            ListTile(
              leading: const Icon(Icons.calendar_month),
              title: const Text("Fecha"),
              subtitle: Text(provider.fecha),
            ),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,

              child: FilledButton.icon(
                onPressed: () {
                  // Más adelante navegará al detalle del lote
                },

                icon: const Icon(Icons.visibility),

                label: const Text("Ver detalle"),
              ),
            ),

          ],
        ),
      ),
    );
  }
}