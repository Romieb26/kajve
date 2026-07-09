import 'package:flutter/material.dart';

import '../providers/history_provider.dart';

class HistoryTable extends StatelessWidget {
  final HistoryProvider provider;

  const HistoryTable({
    super.key,
    required this.provider,
  });

  String _formatearFecha(String iso) {
    final fecha = DateTime.tryParse(iso);
    if (fecha == null) return iso;

    final dia = fecha.day.toString().padLeft(2, '0');
    final mes = fecha.month.toString().padLeft(2, '0');
    final hora = fecha.hour.toString().padLeft(2, '0');
    final minuto = fecha.minute.toString().padLeft(2, '0');
    return "$dia/$mes/${fecha.year}  $hora:$minuto";
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (provider.historial.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Text(
              "No hay eventos para mostrar.",
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    return Column(
      children: provider.historial.map((evento) {
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [

                CircleAvatar(
                  backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.15),
                  child: Icon(Icons.event_note, color: theme.colorScheme.primary),
                ),

                const SizedBox(width: 15),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(evento.tipoEvento, style: theme.textTheme.titleSmall),

                      const SizedBox(height: 4),

                      Text(evento.descripcion, style: theme.textTheme.bodySmall),

                      const SizedBox(height: 4),

                      Text(
                        _formatearFecha(evento.fechaEvento),
                        style: theme.textTheme.bodySmall,
                      ),

                    ],
                  ),
                ),

              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
