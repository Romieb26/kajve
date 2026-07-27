//libs/features/sensors/presentation/pages/create_sensor_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/widgets/app_drawer.dart';

import '../providers/sensor_provider.dart';
import '../widgets/sensor_form.dart';

class CreateSensorPage extends ConsumerWidget {
  const CreateSensorPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(sensorControllerProvider.notifier);

    return Scaffold(
      drawer: const AppDrawer(),

      appBar: AppBar(
        title: const Text("Registrar Sensor"),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            /// Formulario
            const SensorForm(),

            const SizedBox(height: 30),

            FilledButton.icon(
              icon: const Icon(Icons.save),

              label: const Text("Guardar sensor"),

              onPressed: () {

                controller.guardarSensor();

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      "Sensor registrado correctamente.",
                    ),
                  ),
                );

                Navigator.pop(context);
              },
            ),

          ],
        ),
      ),
    );
  }
}
