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
      avatar: const Icon(
        Icons.warning_amber_rounded,
        color: Colors.white,
        size: 18,
      ),
      backgroundColor: color,
      label: Text(
        prioridad,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}