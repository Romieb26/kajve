import 'package:flutter/material.dart';

class SensorCard extends StatelessWidget {

  final String titulo;
  final String valor;
  final IconData icono;

  const SensorCard({
    super.key,
    required this.titulo,
    required this.valor,
    required this.icono,
  });

  @override
  Widget build(BuildContext context) {

    return Card(

      elevation: 4,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),

      child: Padding(
        padding: const EdgeInsets.all(18),

        child: Row(

          children: [

            CircleAvatar(
              radius: 28,
              child: Icon(icono,size:28),
            ),

            const SizedBox(width:18),

            Expanded(
              child: Column(

                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  Text(
                    titulo,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize:17,
                    ),
                  ),

                  Text(
                    valor,
                    style: const TextStyle(
                      fontSize:16,
                    ),
                  ),

                ],
              ),
            )

          ],
        ),
      ),
    );
  }
}