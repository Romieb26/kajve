import 'package:flutter/material.dart';

import '../providers/realtime_provider.dart';

class ChartCard extends StatelessWidget {
  final RealtimeProvider provider;

  const ChartCard({
    super.key,
    required this.provider,
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
                  provider.historial.length,
                      (index) {
                    final value = provider.historial[index];

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
                          "T${index + 1}",
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