import 'package:flutter/material.dart';

class RecentPredictionCard extends StatelessWidget {
  final String lote;
  final String estado;
  final String fecha;

  const RecentPredictionCard({
    super.key,
    required this.lote,
    required this.estado,
    required this.fecha,
  });

  Color _getStatusColor() {
    switch (estado.toLowerCase()) {
      case "secado óptimo":
        return Colors.green;

      case "riesgo de humedad":
        return Colors.orange;

      case "temperatura elevada":
        return Colors.red;

      default:
        return Colors.blueGrey;
    }
  }

  IconData _getStatusIcon() {
    switch (estado.toLowerCase()) {
      case "secado óptimo":
        return Icons.check_circle;

      case "riesgo de humedad":
        return Icons.water_drop;

      case "temperatura elevada":
        return Icons.thermostat;

      default:
        return Icons.analytics;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getStatusColor();

    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.15),
          child: Icon(
            _getStatusIcon(),
            color: color,
          ),
        ),
        title: Text(
          lote,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 4),

            Text(estado),

            const SizedBox(height: 2),

            Text(
              fecha,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),

          ],
        ),
        trailing: SizedBox(
          width: 70,
          child: FilledButton(
            style: FilledButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, 36),
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Mostrando detalles de $lote"),
                ),
              );
            },
            child: const Text("Ver"),
          ),
        ),
        ),
    );
  }
}