import 'package:flutter/material.dart';

import '../../../../shared/widgets/lote_selector_sheet.dart';
import '../providers/history_provider.dart';

class HistoryFilters extends StatelessWidget {
  final HistoryProvider provider;

  const HistoryFilters({
    super.key,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [

            TextField(
              readOnly: true,
              onTap: () => showLoteSelector(
                context,
                onSelected: provider.seleccionarLote,
              ),
              decoration: InputDecoration(
                labelText: provider.loteNombreSeleccionado ?? "Seleccionar lote",
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
                    decoration: InputDecoration(
                      labelText: "Fecha inicio",
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
                    decoration: InputDecoration(
                      labelText: "Fecha fin",
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
                onPressed: provider.solicitandoPdf
                    ? null
                    : () => provider.solicitarPdf(context),
                icon: provider.solicitandoPdf
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.picture_as_pdf),
                label: Text(
                  provider.solicitandoPdf ? "Solicitando..." : "PDF",
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}