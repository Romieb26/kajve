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

          children: [

            const Text(
              "Tendencia de Temperatura",
              style: TextStyle(
                fontSize:20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height:20),

            SizedBox(

              height: 220,

              child: ListView.builder(

                scrollDirection: Axis.horizontal,

                itemCount: provider.historial.length,

                itemBuilder: (_, index) {

                  final value = provider.historial[index];

                  return Padding(

                    padding: const EdgeInsets.symmetric(horizontal:8),

                    child: Column(

                      mainAxisAlignment: MainAxisAlignment.end,

                      children: [

                        Text(value.toString()),

                        const SizedBox(height:8),

                        Container(

                          width: 22,

                          height: value * 5,

                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(10),
                          ),

                        ),

                      ],
                    ),
                  );
                },
              ),
            ),

          ],
        ),
      ),
    );
  }
}