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
      elevation: 4,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),

      child: ListTile(
        leading: CircleAvatar(
          child: Icon(icono),
        ),

        title: Text(
          titulo,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        subtitle: Text(valor),
      ),
    );
  }
}