import 'package:flutter/material.dart';

import '../providers/ history_provider.dart';

class HistoryStatistics extends StatelessWidget {
  final HistoryProvider provider;

  const HistoryStatistics({
    super.key,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    final total = provider.historial.length;

    double promedioTemp = 0;
    double promedioHum = 0;

    if (total > 0) {
      promedioTemp = provider.historial
          .map((e) => e.temperatura)
          .reduce((a, b) => a + b) /
          total;

      promedioHum = provider.historial
          .map((e) => e.humedad)
          .reduce((a, b) => a + b) /
          total;
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            const Text(
              "Estadísticas",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const Divider(height: 30),

            ListTile(
              leading: const Icon(Icons.list_alt),
              title: const Text("Total de registros"),
              trailing: Text(
                total.toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            ListTile(
              leading: const Icon(Icons.thermostat),
              title: const Text("Temperatura promedio"),
              trailing: Text(
                "${promedioTemp.toStringAsFixed(1)} °C",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            ListTile(
              leading: const Icon(Icons.water_drop),
              title: const Text("Humedad promedio"),
              trailing: Text(
                "${promedioHum.toStringAsFixed(1)} %",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}