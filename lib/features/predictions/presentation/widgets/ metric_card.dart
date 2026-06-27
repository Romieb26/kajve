import 'package:flutter/material.dart';

class MetricCard extends StatelessWidget {

  final String titulo;
  final String valor;
  final IconData icono;

  const MetricCard({
    super.key,
    required this.titulo,
    required this.valor,
    required this.icono,
  });

  @override
  Widget build(BuildContext context) {

    return Card(

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),

      child: Padding(
        padding: const EdgeInsets.all(18),

        child: Row(

          children: [

            Icon(icono,size:32),

            const SizedBox(width:20),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    titulo,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Text(valor),

                ],
              ),
            )

          ],
        ),
      ),
    );
  }
}