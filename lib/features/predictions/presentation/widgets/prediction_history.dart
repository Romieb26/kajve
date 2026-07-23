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
              // ListView.builder en vez de "...predicciones.map(...)" dentro de la Column: el
              // backend ya limita a las 30 más recientes (ver predictions_remote_datasource.dart),
              // pero además esto evita construir de una sola vez cada ListTile si algún día ese
              // límite cambia. shrinkWrap+NeverScrollableScrollPhysics porque esta tarjeta ya vive
              // dentro del SingleChildScrollView de prediction_page.dart.
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: predicciones.length,
                itemBuilder: (context, index) {
                  final prediccion = predicciones[index];
                  return ListTile(
                    leading: const Icon(Icons.history),

                    title: Text(
                      prediccion.calidadEstimada != null
                          ? "Calidad estimada: ${prediccion.calidadEstimada!.toStringAsFixed(0)}/100 (SCA)"
                          : "Calidad estimada: sin datos suficientes",
                    ),

                    subtitle: Text(
                      "Confianza: ${prediccion.confianza.toStringAsFixed(0)}% · "
                      "${prediccion.fechaPrediccion ?? 'Sin fecha'}"
                      "${prediccion.riesgoLluviaProxima == true ? ' · Riesgo de lluvia' : ''}",
                    ),

                    trailing: Text(
                      "${prediccion.tiempoEstimadoHoras.toStringAsFixed(1)} h",
                    ),
                  );
                },
              ),

          ],
        ),
      ),
    );
  }
}
