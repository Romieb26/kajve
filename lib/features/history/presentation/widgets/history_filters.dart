import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/widgets/lote_selector_sheet.dart';
import '../providers/history_provider.dart';

class HistoryFilters extends ConsumerWidget {
  final HistoryState state;
  final HistoryController controller;

  const HistoryFilters({
    super.key,
    required this.state,
    required this.controller,
  });

  String _formatearFecha(DateTime fecha) {
    final dia = fecha.day.toString().padLeft(2, '0');
    final mes = fecha.month.toString().padLeft(2, '0');
    return "$dia/$mes/${fecha.year}";
  }

  Future<void> _elegirFecha(
    BuildContext context,
    DateTime? actual,
    ValueChanged<DateTime> onElegida,
  ) async {
    final fecha = await showDatePicker(
      context: context,
      initialDate: actual ?? DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime.now(),
    );
    if (fecha != null) onElegida(fecha);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [

            TextField(
              readOnly: true,
              onTap: () => showLoteSelector(
                context,
                ref,
                onSelected: controller.seleccionarLote,
              ),
              decoration: InputDecoration(
                labelText: state.loteNombreSeleccionado ?? "Seleccionar lote",
                prefixIcon: const Icon(Icons.agriculture_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 15),

            Row(
              children: [

                Expanded(
                  child: TextField(
                    readOnly: true,
                    onTap: () => _elegirFecha(
                      context,
                      state.fechaInicioSeleccionada,
                      controller.seleccionarFechaInicio,
                    ),
                    decoration: InputDecoration(
                      labelText: state.fechaInicioSeleccionada != null
                          ? _formatearFecha(state.fechaInicioSeleccionada!)
                          : "Fecha inicio",
                      prefixIcon: const Icon(Icons.calendar_today),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: TextField(
                    readOnly: true,
                    onTap: () => _elegirFecha(
                      context,
                      state.fechaFinSeleccionada,
                      controller.seleccionarFechaFin,
                    ),
                    decoration: InputDecoration(
                      labelText: state.fechaFinSeleccionada != null
                          ? _formatearFecha(state.fechaFinSeleccionada!)
                          : "Fecha fin",
                      prefixIcon: const Icon(Icons.calendar_today),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),

              ],
            ),

            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: state.solicitandoPdf
                    ? null
                    : () => controller.solicitarPdf(context),
                icon: state.solicitandoPdf
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.picture_as_pdf),
                label: Text(
                  state.solicitandoPdf ? "Solicitando..." : "PDF",
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
