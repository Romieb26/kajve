import 'package:flutter/material.dart';
import '../providers/realtime_provider.dart';
import '../widgets/sensor_card.dart';



class SensorGrid extends StatelessWidget {
  final RealtimeProvider provider;

  const SensorGrid({
    super.key,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 15,
      mainAxisSpacing: 15,
      childAspectRatio: 1.2,
      children: [

        SensorCard(
          titulo: "Temperatura",
          valor: "${provider.temperatura} °C",
          icono: Icons.thermostat,
        ),

        SensorCard(
          titulo: "Humedad",
          valor: "${provider.humedad} %",
          icono: Icons.water_drop,
        ),

        SensorCard(
          titulo: "Humedad Grano",
          valor: "${provider.humedadGrano} %",
          icono: Icons.grass,
        ),

        SensorCard(
          titulo: "Viento",
          valor: "12 km/h", // temporal o agrégalo al provider
          icono: Icons.air,
        ),

      ],
    );
  }
}