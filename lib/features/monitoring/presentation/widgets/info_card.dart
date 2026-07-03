import 'package:flutter/material.dart';

import '../providers/monitoring_provider.dart';
import '../widgets/sensor_status_card.dart';


class InfoCard extends StatelessWidget {
  final MonitoringProvider provider;

  const InfoCard({
    super.key,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),

      child: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              "Información del lote",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const Divider(height: 30),

            _fila("Etapa", provider.etapa),
            _fila("Calidad SCA", provider.calidad),
            _fila("Días de secado", provider.diasSecado),
            _fila("Rendimiento", provider.rendimiento),

            const SizedBox(height: 20),

            SensorStatusCard(
              titulo: "Humedad",
              valor: "${provider.humedad} %",
              icono: Icons.water_drop,
            ),

            const SizedBox(height: 12),

            SensorStatusCard(
              titulo: "Temperatura",
              valor: "${provider.temperatura} °C",
              icono: Icons.thermostat,
            ),
          ],
        ),
      ),
    );
  }

  Widget _fila(String titulo, String valor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(titulo),
          Text(
            valor,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}