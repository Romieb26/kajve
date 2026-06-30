import 'package:flutter/material.dart';

class SensorStatusChip extends StatelessWidget {

  final bool conectado;

  const SensorStatusChip({
    super.key,
    required this.conectado,
  });

  @override
  Widget build(BuildContext context) {

    return Chip(
      avatar: Icon(
        conectado
            ? Icons.check_circle
            : Icons.cancel,
        color: Colors.white,
        size: 18,
      ),
      label: Text(
        conectado
            ? "Conectado"
            : "Desconectado",
      ),
      backgroundColor:
      conectado ? Colors.green : Colors.red,
      labelStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}