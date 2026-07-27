import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/lot_provider.dart';

class SensorCard extends ConsumerWidget {
  const SensorCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.read(lotControllerProvider.notifier);
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.sensors, color: theme.colorScheme.primary),
                const SizedBox(width: 10),
                Text("Asociar sensores", style: theme.textTheme.titleMedium),
              ],
            ),

            const SizedBox(height: 15),

            TextField(
              controller: provider.sensorIdController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "ID de sensor (opcional)",
                helperText:
                    "Déjalo vacío si el lote no tiene sensor asignado.",
                prefixIcon: const Icon(Icons.pin_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
