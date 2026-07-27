//libs/features/sensors/presentation/pages/sensors_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/widgets/app_drawer.dart';

import '../providers/sensor_provider.dart';
import '../widgets/search_sensor.dart';
import '../widgets/sensor_card.dart';
import 'create_sensor_page.dart';

class SensorsPage extends ConsumerWidget {
  const SensorsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(sensorControllerProvider);
    final controller = ref.read(sensorControllerProvider.notifier);

    return Scaffold(
      drawer: const AppDrawer(),

      appBar: AppBar(
        title: const Text("Sensores"),
        centerTitle: true,
      ),

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CreateSensorPage(),
            ),
          );
        },
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            /// Buscador
            SearchSensor(
              provider: controller,
            ),

            const SizedBox(height: 20),

            /// Lista de sensores
            Expanded(
              child: _Contenido(state: state, controller: controller),
            ),

          ],
        ),
      ),
    );
  }
}

class _Contenido extends StatelessWidget {
  final SensorState state;
  final SensorController controller;

  const _Contenido({required this.state, required this.controller});

  @override
  Widget build(BuildContext context) {
    if (state.isLoading && state.sensores.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.errorMessage != null && state.sensores.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.cloud_off, size: 48, color: Colors.grey),
              const SizedBox(height: 12),
              Text(state.errorMessage!, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: controller.cargarSensores,
                child: const Text("Reintentar"),
              ),
            ],
          ),
        ),
      );
    }

    if (state.sensores.isEmpty) {
      return RefreshIndicator(
        onRefresh: controller.cargarSensores,
        child: ListView(
          children: const [
            SizedBox(height: 80),
            Center(
              child: Text(
                "No tienes sensores vinculados a ningún lote activo.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: controller.cargarSensores,
      child: ListView.builder(
        itemCount: state.sensores.length,
        itemBuilder: (context, index) {
          return SensorCard(
            sensor: state.sensores[index],
          );
        },
      ),
    );
  }
}
