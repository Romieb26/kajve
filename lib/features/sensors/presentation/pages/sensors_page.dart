//libs/features/sensors/presentation/pages/sensors_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../shared/widgets/app_drawer.dart';

import '../providers/sensor_provider.dart';
import '../widgets/search_sensor.dart';
import '../widgets/sensor_card.dart';
import 'create_sensor_page.dart';

class SensorsPage extends StatelessWidget {
  const SensorsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SensorProvider>(
      builder: (context, provider, child) {
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
                  provider: provider,
                ),

                const SizedBox(height: 20),

                /// Lista de sensores
                Expanded(
                  child: _Contenido(provider: provider),
                ),

              ],
            ),
          ),
        );
      },
    );
  }
}

class _Contenido extends StatelessWidget {
  final SensorProvider provider;

  const _Contenido({required this.provider});

  @override
  Widget build(BuildContext context) {
    if (provider.isLoading && provider.sensores.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.errorMessage != null && provider.sensores.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.cloud_off, size: 48, color: Colors.grey),
              const SizedBox(height: 12),
              Text(provider.errorMessage!, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: provider.cargarSensores,
                child: const Text("Reintentar"),
              ),
            ],
          ),
        ),
      );
    }

    if (provider.sensores.isEmpty) {
      return RefreshIndicator(
        onRefresh: provider.cargarSensores,
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
      onRefresh: provider.cargarSensores,
      child: ListView.builder(
        itemCount: provider.sensores.length,
        itemBuilder: (context, index) {
          return SensorCard(
            sensor: provider.sensores[index],
          );
        },
      ),
    );
  }
}
