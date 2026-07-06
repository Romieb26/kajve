import 'package:flutter/material.dart';

import '../../../monitoring/domain/entities/estadisticas_entity.dart';

class EnvironmentCard extends StatelessWidget {
  final EstadisticasEntity? estadisticas;

  const EnvironmentCard({
    super.key,
    required this.estadisticas,
  });

  @override
  Widget build(BuildContext context) {
    final alertasCriticas = estadisticas?.alertasCriticas ?? 0;
    final alertasSinAtender = estadisticas?.alertasSinAtender ?? 0;

    final String estadoTexto;
    final Color estadoColor;

    if (alertasCriticas > 0) {
      estadoTexto = "Atención: alertas críticas activas";
      estadoColor = Colors.red;
    } else if (alertasSinAtender > 0) {
      estadoTexto = "Hay alertas sin atender";
      estadoColor = Colors.orange;
    } else {
      estadoTexto = "Sistema estable";
      estadoColor = Colors.green;
    }

    return Card(
      elevation: 4,

      child: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            const Text(
              "Estado General",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const Divider(),

            ListTile(
              leading: Icon(
                Icons.check_circle,
                color: estadoColor,
              ),

              title: Text(estadoTexto),
            ),

            ListTile(
              leading: const Icon(Icons.warning_amber),

              title: const Text("Alertas críticas"),

              trailing: Text("$alertasCriticas"),
            ),

          ],
        ),
      ),
    );
  }
}
