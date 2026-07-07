import 'package:flutter/material.dart';

class LotCard extends StatelessWidget {

  final String nombre;
  final String fecha;
  final String estado;
  final Color colorEstado;

  const LotCard({
    super.key,
    required this.nombre,
    required this.fecha,
    required this.estado,
    required this.colorEstado,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: colorEstado.withValues(alpha: 0.15),
              child: Icon(Icons.grass, color: colorEstado),
            ),

            const SizedBox(width: 15),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    nombre,
                    style: theme.textTheme.titleMedium,
                  ),

                  const SizedBox(height: 4),

                  Text(
                    "Registrado: $fecha",
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),

            const SizedBox(width: 10),

            Chip(
              label: Text(estado),
              backgroundColor: colorEstado.withValues(alpha: 0.18),
              labelStyle: TextStyle(
                color: colorEstado,
                fontWeight: FontWeight.w600,
              ),
              side: BorderSide.none,
            ),
          ],
        ),
      ),
    );
  }
}
