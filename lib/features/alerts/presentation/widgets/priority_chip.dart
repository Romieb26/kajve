import 'package:flutter/material.dart';

class PriorityChip extends StatelessWidget {
  final String prioridad;

  const PriorityChip({
    super.key,
    required this.prioridad,
  });

  @override
  Widget build(BuildContext context) {
    Color color;

    switch (prioridad.toLowerCase()) {
      case 'critica':
        color = Colors.red.shade900;
        break;

      case 'alta':
        color = Colors.red;
        break;

      case 'media':
        color = Colors.orange;
        break;

      default:
        color = Colors.green;
    }

    return Chip(
      avatar: Icon(
        Icons.warning_amber_rounded,
        color: color,
        size: 18,
      ),
      backgroundColor: color.withValues(alpha: 0.18),
      label: Text(
        prioridad,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
      side: BorderSide.none,
    );
  }
}