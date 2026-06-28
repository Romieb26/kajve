import 'package:flutter/material.dart';

import '../providers/realtime_provider.dart';

class RealtimeHeader extends StatelessWidget {
  final RealtimeProvider provider;

  const RealtimeHeader({
    super.key,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,

      child: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            Text(
              provider.nombreLote,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              "Última actualización",
              style: TextStyle(
                color: Colors.grey[700],
              ),
            ),

            Text(
              provider.ultimaActualizacion,
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