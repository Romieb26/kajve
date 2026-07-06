import 'package:flutter/material.dart';

import '../../../monitoring/domain/entities/lectura_entity.dart';

class ChartCard extends StatelessWidget {
  final List<LecturaEntity> lecturas;

  const ChartCard({
    super.key,
    required this.lecturas,
  });

  @override
  Widget build(BuildContext context) {
    if (lecturas.isEmpty) {
      return Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Padding(
          padding: EdgeInsets.all(20),
          child: Center(
            child: Text(
              "Sin lecturas registradas aún",
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ),
      );
    }

    // Toma como máximo las últimas 9 lecturas para no saturar el gráfico.
    final datos = lecturas.length > 9
        ? lecturas.sublist(lecturas.length - 9)
        : lecturas;

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

            const Row(
              children: [

                Icon(
                  Icons.show_chart,
                  color: Colors.orange,
                ),

                SizedBox(width: 10),

                Text(
                  "Tendencia de Temperatura",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

              ],
            ),

            const SizedBox(height: 25),

            SizedBox(
              height: 220,

              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                children: List.generate(
                  datos.length,
                      (index) {
                    final value = datos[index].temperatura;

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.end,

                      children: [

                        Text(
                          "${value.toStringAsFixed(0)}°",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 8),

                        AnimatedContainer(
                          duration: const Duration(milliseconds: 500),

                          width: 26,

                          height: value * 5,

                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          "L${index + 1}",
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),

                      ],
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 15),

            const Center(
              child: Text(
                "Historial de temperatura del lote",
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
