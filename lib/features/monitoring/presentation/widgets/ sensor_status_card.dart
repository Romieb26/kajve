import 'package:flutter/material.dart';

class SensorStatusCard extends StatelessWidget {

  final String titulo;
  final String valor;

  const SensorStatusCard({
    super.key,
    required this.titulo,
    required this.valor,
  });

  @override
  Widget build(BuildContext context) {

    return Container(

      padding: const EdgeInsets.all(12),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),

      child: Row(

        children: [

          const Icon(Icons.sensors),

          const SizedBox(width:10),

          Expanded(
            child: Text(titulo),
          ),

          Text(
            valor,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

        ],
      ),
    );
  }
}