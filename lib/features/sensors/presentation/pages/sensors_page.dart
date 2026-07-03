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
                  child: ListView.builder(
                    itemCount: provider.sensores.length,
                    itemBuilder: (context, index) {
                      return SensorCard(
                        sensor: provider.sensores[index],
                      );
                    },
                  ),
                ),

              ],
            ),
          ),
        );
      },
    );
  }
}