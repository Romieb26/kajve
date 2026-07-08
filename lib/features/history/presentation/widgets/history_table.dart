import 'package:flutter/material.dart';

import '../providers/history_provider.dart';

class HistoryTable extends StatelessWidget {
  final HistoryProvider provider;

  const HistoryTable({
    super.key,
    required this.provider,
  });

  Color _estadoColor(String estado) {
    switch (estado) {
      case "Óptimo":
        return Colors.green;

      case "Bueno":
        return Colors.blue;

      case "Alerta":
        return Colors.orange;

      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (provider.historial.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Text(
              "No hay registros para mostrar.",
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    return Column(
      children: provider.historial.map((item) {
        final color = _estadoColor(item.estado);

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [

                CircleAvatar(
                  backgroundColor: color.withValues(alpha: 0.15),
                  child: Icon(Icons.grass, color: color),
                ),

                const SizedBox(width: 15),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(item.lote, style: theme.textTheme.titleSmall),

                      const SizedBox(height: 4),

                      Text(item.fecha, style: theme.textTheme.bodySmall),

                      const SizedBox(height: 4),

                      Text(
                        "${item.temperatura} °C   •   ${item.humedad} %",
                        style: theme.textTheme.bodySmall,
                      ),

                    ],
                  ),
                ),

                const SizedBox(width: 10),

                Chip(
                  label: Text(item.estado),
                  backgroundColor: color.withValues(alpha: 0.18),
                  labelStyle: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                  side: BorderSide.none,
                ),

              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}