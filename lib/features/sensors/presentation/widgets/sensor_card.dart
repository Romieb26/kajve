//libs/features/sensors/presentation/widgets/sensor_card.dart
import 'package:flutter/material.dart';

import '../../data/models/sensor_model.dart';
import '../pages/sensor_detail_page.dart';

class SensorCard extends StatelessWidget {
  final SensorModel sensor;

  const SensorCard({
    super.key,
    required this.sensor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = sensor.colorEstado;

    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SensorDetailPage(sensor: sensor),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [

              CircleAvatar(
                radius: 26,
                backgroundColor: color.withValues(alpha: 0.15),
                child: Icon(Icons.sensors, color: color),
              ),

              const SizedBox(width: 15),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(
                      sensor.nombre,
                      style: theme.textTheme.titleMedium,
                    ),

                    const SizedBox(height: 4),

                    Text(
                      "Tipo: ${sensor.tipo}",
                      style: theme.textTheme.bodySmall,
                    ),

                    Text(
                      "Código: ${sensor.codigo}",
                      style: theme.textTheme.bodySmall,
                    ),

                    Text(
                      "Lote: ${sensor.lote}",
                      style: theme.textTheme.bodySmall,
                    ),

                  ],
                ),
              ),

              const SizedBox(width: 10),

              Chip(
                label: Text(sensor.estado),
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
      ),
    );
  }
}
