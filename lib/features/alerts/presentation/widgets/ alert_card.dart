import 'package:flutter/material.dart';
import '../../data/models/alert_model.dart';

class AlertCard extends StatelessWidget {
  final AlertModel alert;

  const AlertCard({
    super.key,
    required this.alert,
  });

  Color _color() {
    switch (alert.nivel) {
      case "alta":
        return Colors.red;

      case "media":
        return Colors.orange;

      default:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),

      child: ListTile(
        leading: Icon(
          Icons.warning,
          color: _color(),
        ),

        title: Text(alert.titulo),

        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(alert.descripcion),
            Text(alert.fecha),
          ],
        ),
      ),
    );
  }
}