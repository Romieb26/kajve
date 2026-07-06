import 'package:flutter/material.dart';

import '../../../monitoring/domain/entities/estadisticas_entity.dart';

class RealtimeHeader extends StatelessWidget {
  final int loteId;
  final EstadisticasEntity? estadisticas;

  const RealtimeHeader({
    super.key,
    required this.loteId,
    required this.estadisticas,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,

      child: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            Text(
              "Lote #$loteId",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              "Última lectura",
              style: TextStyle(
                color: Colors.grey[700],
              ),
            ),

            Text(
              estadisticas?.ultimaLectura ?? "Sin datos",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

          ],
        ),
      ),
    );
  }
}
