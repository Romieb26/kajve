import 'package:flutter/material.dart';

import '../providers/history_provider.dart';

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

    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            Row(
              children: [
                Icon(Icons.insights_outlined, color: theme.colorScheme.primary),
                const SizedBox(width: 10),
                Text("Estadísticas", style: theme.textTheme.titleMedium),
              ],
            ),

            const Divider(height: 30),

            ListTile(
              leading: Icon(Icons.list_alt, color: theme.colorScheme.primary),
              title: const Text("Total de registros"),
              trailing: Text(
                total.toString(),
                style: theme.textTheme.titleSmall,
              ),
            ),

            ListTile(
              leading: Icon(Icons.thermostat, color: theme.colorScheme.primary),
              title: const Text("Temperatura promedio"),
              trailing: Text(
                "${promedioTemp.toStringAsFixed(1)} °C",
                style: theme.textTheme.titleSmall,
              ),
            ),

            ListTile(
              leading: Icon(Icons.water_drop, color: theme.colorScheme.primary),
              title: const Text("Humedad promedio"),
              trailing: Text(
                "${promedioHum.toStringAsFixed(1)} %",
                style: theme.textTheme.titleSmall,
              ),
            ),

          ],
        ),
      ),
    );
  }
}