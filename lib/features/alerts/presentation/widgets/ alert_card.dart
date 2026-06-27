import 'package:flutter/material.dart';

import '../providers/alerts_provider.dart';
import 'priority_chip.dart';

class AlertCard extends StatelessWidget {
  final AlertModel alert;
  final VoidCallback onPressed;

  const AlertCard({
    super.key,
    required this.alert,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Row(
              children: [

                Expanded(
                  child: Text(
                    alert.titulo,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),

                PriorityChip(
                  prioridad: alert.prioridad,
                ),

              ],
            ),

            const SizedBox(height: 12),

            Text(
              alert.descripcion,
              style: const TextStyle(fontSize: 15),
            ),

            const SizedBox(height: 18),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [

                OutlinedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text("Detalle"),
                        content: Text(alert.descripcion),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Cerrar"),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: const Icon(Icons.visibility),
                  label: const Text("Ver detalle"),
                ),

                const SizedBox(width: 10),

                ElevatedButton.icon(
                  onPressed: alert.revisada ? null : onPressed,
                  icon: Icon(
                    alert.revisada
                        ? Icons.check_circle
                        : Icons.check,
                  ),
                  label: Text(
                    alert.revisada
                        ? "Revisada"
                        : "Marcar",
                  ),
                ),

              ],
            ),

          ],
        ),
      ),
    );
  }
}