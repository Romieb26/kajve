import 'package:flutter/material.dart';

import '../../domain/entities/alerta_entity.dart';
import 'priority_chip.dart';

class AlertCard extends StatelessWidget {
  final AlertaEntity alert;
  final VoidCallback? onAtender;

  const AlertCard({
    super.key,
    required this.alert,
    this.onAtender,
  });

  Color _color() {
    switch (alert.nivelSeveridad.toLowerCase()) {
      case "critica":
        return Colors.red.shade900;

      case "alta":
        return Colors.red;

      case "media":
        return Colors.orange;

      default:
        return Colors.green;
    }
  }

  IconData _icon() {
    switch (alert.nivelSeveridad.toLowerCase()) {
      case "critica":
      case "alta":
        return Icons.warning;

      case "media":
        return Icons.error_outline;

      default:
        return Icons.check_circle;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Row(
              children: [

                CircleAvatar(
                  backgroundColor: _color().withValues(alpha: .15),
                  child: Icon(
                    _icon(),
                    color: _color(),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Text(
                    alert.tipoAlerta,
                    style: theme.textTheme.titleMedium,
                  ),
                ),

                PriorityChip(
                  prioridad: alert.nivelSeveridad,
                ),

              ],
            ),

            const SizedBox(height: 15),

            Text(alert.mensaje, style: theme.textTheme.bodyMedium),

            const SizedBox(height: 10),

            Row(
              children: [

                Icon(
                  Icons.calendar_today,
                  size: 18,
                  color: theme.textTheme.bodySmall?.color,
                ),

                const SizedBox(width: 8),

                Text(
                  alert.fechaGenerada,
                  style: theme.textTheme.bodySmall,
                ),

              ],
            ),

            if (!alert.atendida && onAtender != null) ...[

              const SizedBox(height: 12),

              Align(
                alignment: Alignment.centerRight,
                child: OutlinedButton.icon(
                  onPressed: onAtender,
                  icon: const Icon(Icons.check),
                  label: const Text("Atender"),
                ),
              ),

            ],

          ],
        ),
      ),
    );
  }
}
