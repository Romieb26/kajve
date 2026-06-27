import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/realtime_provider.dart';
import '../widgets/ chart_card.dart';
import '../widgets/ sensor_card.dart';

class RealtimePage extends StatelessWidget {
  const RealtimePage({super.key});

  @override
  Widget build(BuildContext context) {

    final provider = Provider.of<RealtimeProvider>(context);

    return Scaffold(

      backgroundColor: const Color(0xffB56A1F),

      appBar: AppBar(
        backgroundColor: const Color(0xff6A3C18),
        title: const Text("Monitoreo en Tiempo Real"),
        centerTitle: true,
      ),

      body: SingleChildScrollView(

        padding: const EdgeInsets.all(16),

        child: Column(

          children: [

            SensorCard(
              titulo: "Temperatura",
              valor: "${provider.temperatura} °C",
              icono: Icons.thermostat,
            ),

            const SizedBox(height:15),

            SensorCard(
              titulo: "Humedad Ambiente",
              valor: "${provider.humedad} %",
              icono: Icons.water_drop,
            ),

            const SizedBox(height:15),

            SensorCard(
              titulo: "Humedad del Grano",
              valor: "${provider.humedadGrano} %",
              icono: Icons.grass,
            ),

            const SizedBox(height:20),

            ChartCard(provider: provider),

          ],
        ),
      ),
    );
  }
}