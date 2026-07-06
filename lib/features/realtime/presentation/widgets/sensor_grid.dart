import 'package:flutter/material.dart';

import '../../../monitoring/domain/entities/lectura_entity.dart';
import '../widgets/sensor_card.dart';

class SensorGrid extends StatelessWidget {
  final LecturaEntity? ultimaLectura;

  const SensorGrid({
    super.key,
    required this.ultimaLectura,
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
          valor: ultimaLectura != null
              ? "${ultimaLectura!.temperatura.toStringAsFixed(1)} °C"
              : "--",
          icono: Icons.thermostat,
        ),

        SensorCard(
          titulo: "Humedad",
          valor: ultimaLectura != null
              ? "${ultimaLectura!.humedad.toStringAsFixed(1)} %"
              : "--",
          icono: Icons.water_drop,
        ),

      ],
    );
  }
}
