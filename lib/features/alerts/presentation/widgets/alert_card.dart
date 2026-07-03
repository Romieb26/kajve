import 'package:flutter/material.dart';

import '../../data/models/alert_model.dart';
import 'priority_chip.dart';

class AlertCard extends StatelessWidget {
  final AlertModel alert;

  const AlertCard({
    super.key,
    required this.alert,
  });

  Color _color() {
    switch (alert.nivel.toLowerCase()) {
      case "alta":
        return Colors.red;

      case "media":
        return Colors.orange;

      default:
        return Colors.green;
    }
  }

  IconData _icon() {
    switch (alert.nivel.toLowerCase()) {
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
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Row(
              children: [

                CircleAvatar(
                  backgroundColor: _color().withOpacity(.15),
                  child: Icon(
                    _icon(),
                    color: _color(),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Text(
                    alert.titulo,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                ),

                PriorityChip(
                  prioridad: alert.nivel,
                ),

              ],
            ),

            const SizedBox(height: 15),

            Text(alert.descripcion),

            const SizedBox(height: 10),

            Row(
              children: [

                const Icon(
                  Icons.calendar_today,
                  size: 18,
                  color: Colors.grey,
                ),

                const SizedBox(width: 8),

                Text(
                  alert.fecha,
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),

              ],
            ),

          ],
        ),
      ),
    );
  }
}