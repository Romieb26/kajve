import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../shared/widgets/app_drawer.dart';

import '../providers/realtime_provider.dart';

import '../widgets/realtime_header.dart';
import '../widgets/sensor_grid.dart';
import '../widgets/environment_card.dart';
import '../widgets/chart_card.dart';

class RealtimePage extends StatelessWidget {
  const RealtimePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RealtimeProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          drawer: const AppDrawer(),

          appBar: AppBar(
            title: const Text("Tiempo Real"),
            centerTitle: true,
          ),

          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [

                RealtimeHeader(
                  provider: provider,
                ),

                const SizedBox(height: 20),

                SensorGrid(
                  provider: provider,
                ),

                const SizedBox(height: 20),

                ChartCard(
                  provider: provider,
                ),

                const SizedBox(height: 20),

                EnvironmentCard(
                  provider: provider,
                ),

              ],
            ),
          ),
        );
      },
    );
  }
}