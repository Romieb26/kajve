import 'package:flutter/material.dart';

class SensorStatusCard extends StatelessWidget {
  final String titulo;
  final String valor;
  final IconData icono;

  const SensorStatusCard({
    super.key,
    required this.titulo,
    required this.valor,
    required this.icono,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),

      child: Padding(
        padding: const EdgeInsets.all(15),

        child: Row(
          children: [

            CircleAvatar(
              child: Icon(icono),
            ),

            const SizedBox(width: 15),

            Expanded(
              child: Text(
                titulo,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            Text(
              valor,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),

          ],
        ),
      ),
    );
  }
}