//libs/features/realtime/presentation/widgets/realtime_header.dart
import 'package:flutter/material.dart';

class RealtimeHeader extends StatelessWidget {
  final int loteId;

  /// Timestamp de la última lectura recibida por el WebSocket (en vivo).
  /// Antes esto salía de /lotes/{id}/estadisticas (api-mobile), que puede
  /// fallar por razones que no tienen nada que ver con si hay datos en
  /// vivo o no — mostraba "Sin datos" aunque las gráficas de abajo
  /// estuvieran actualizándose con normalidad. Ahora sale directo de la
  /// misma fuente que ya alimenta todo lo demás en esta pantalla.
  final DateTime? ultimaLectura;

  const RealtimeHeader({
    super.key,
    required this.loteId,
    required this.ultimaLectura,
  });

  String _formatear(DateTime fecha) {
    final hora = fecha.hour.toString().padLeft(2, '0');
    final minuto = fecha.minute.toString().padLeft(2, '0');
    final segundo = fecha.second.toString().padLeft(2, '0');
    return "$hora:$minuto:$segundo";
  }

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
              ultimaLectura != null
                  ? _formatear(ultimaLectura!.toLocal())
                  : "Esperando datos...",
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
