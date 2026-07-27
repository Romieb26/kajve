//libs/features/sensors/presentation/widgets/sensor_form.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/sensor_provider.dart';

class SensorForm extends ConsumerWidget {
  const SensorForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(sensorControllerProvider);
    final provider = ref.read(sensorControllerProvider.notifier);
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            Row(
              children: [
                Icon(Icons.sensors, color: theme.colorScheme.primary),
                const SizedBox(width: 10),
                Text("Datos del sensor", style: theme.textTheme.titleMedium),
              ],
            ),

            const SizedBox(height: 20),

            /// Nombre
            TextField(
              controller: provider.nombreController,
              decoration: InputDecoration(
                labelText: "Nombre del sensor",
                prefixIcon: const Icon(Icons.badge_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 15),

            /// Tipo
            TextField(
              controller: provider.tipoController,
              decoration: InputDecoration(
                labelText: "Tipo de sensor",
                prefixIcon: const Icon(Icons.category_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 15),

            /// Código
            TextField(
              controller: provider.codigoController,
              decoration: InputDecoration(
                labelText: "Código",
                prefixIcon: const Icon(Icons.qr_code),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 15),

            /// Lote
            TextField(
              controller: provider.loteController,
              decoration: InputDecoration(
                labelText: "Lote asociado",
                prefixIcon: const Icon(Icons.agriculture_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            SwitchListTile(
              value: state.conectado,
              onChanged: provider.cambiarEstado,
              title: const Text("Sensor conectado"),
              secondary: Icon(Icons.wifi, color: theme.colorScheme.primary),
            ),
          ],
        ),
      ),
    );
  }
}
