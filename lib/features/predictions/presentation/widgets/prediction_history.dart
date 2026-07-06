import 'package:flutter/material.dart';

import '../../domain/entities/prediccion_entity.dart';

class PredictionHistory extends StatelessWidget {
  final List<PrediccionEntity> predicciones;

  const PredictionHistory({
    super.key,
    required this.predicciones,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),

      child: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            const Text(
              "Historial de Predicciones",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const Divider(),

            if (predicciones.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  "Aún no hay predicciones para este lote.",
                  style: TextStyle(color: Colors.grey),
                ),
              )
            else
              ...predicciones.map(
                (prediccion) => ListTile(
                  leading: const Icon(Icons.history),

                  title: Text(
                    "Calidad estimada: ${prediccion.calidadEstimada}",
                  ),

                  subtitle: Text(
                    "Confianza: ${prediccion.confianza}% · "
                    "${prediccion.fechaPrediccion ?? 'Sin fecha'}",
                  ),

                  trailing: Text(
                    "${prediccion.tiempoEstimadoHoras.toStringAsFixed(1)} h",
                  ),
                ),
              ),

          ],
        ),
      ),
    );
  }
}
