import 'package:flutter/material.dart';

import '../providers/monitoring_provider.dart';
import '../widgets/ sensor_status_card.dart';

class InfoCard extends StatelessWidget {

  final MonitoringProvider provider;

  const InfoCard({
    super.key,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.all(15),

      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.circular(20),
      ),

      child: Column(

        children: [

          const Text(
            "Información general",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize:18,
            ),
          ),

          const SizedBox(height:15),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Etapa"),
              Text(provider.etapa),
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Calidad SCA"),
              Text(provider.calidad),
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Días de Secado"),
              Text(provider.diasSecado),
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Rendimiento"),
              Text(provider.rendimiento),
            ],
          ),

          const SizedBox(height:20),

          SensorStatusCard(
            titulo: "Humedad del suelo",
            valor: "${provider.humedad} %",
          ),

          const SizedBox(height:10),

          SensorStatusCard(
            titulo: "Temperatura del aire",
            valor: "${provider.temperatura} °C",
          ),
        ],
      ),
    );
  }
}