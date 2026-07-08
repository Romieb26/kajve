import 'package:flutter/material.dart';

import '../../../../shared/widgets/lote_selector_sheet.dart';
import '../providers/report_provider.dart';

class ReportForm extends StatelessWidget {
  final ReportProvider provider;

  const ReportForm({
    super.key,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            Row(
              children: [
                Icon(Icons.tune, color: theme.colorScheme.primary),
                const SizedBox(width: 10),
                Text("Parámetros del reporte", style: theme.textTheme.titleMedium),
              ],
            ),

            const SizedBox(height: 20),

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

            DropdownButtonFormField<String>(
              value: provider.tipoReporte,
              decoration: InputDecoration(
                labelText: "Tipo de reporte",
                prefixIcon: const Icon(Icons.description_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: provider.tipos.map((tipo) {
                return DropdownMenuItem(
                  value: tipo,
                  child: Text(tipo),
                );
              }).toList(),
              onChanged: provider.seleccionarTipo,
            ),

            const SizedBox(height: 20),

            Align(
              alignment: Alignment.centerLeft,
              child: Text("Formato", style: theme.textTheme.bodySmall),
            ),

            const SizedBox(height: 8),

            Wrap(
              spacing: 10,
              children: [
                ChoiceChip(
                  label: const Text("PDF"),
                  selected: provider.formato == "pdf",
                  onSelected: (_) => provider.seleccionarFormato("pdf"),
                ),
                ChoiceChip(
                  label: const Text("Excel"),
                  selected: provider.formato == "excel",
                  onSelected: (_) => provider.seleccionarFormato("excel"),
                ),
              ],
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: provider.solicitando
                    ? null
                    : () => provider.generarReporte(context),
                icon: provider.solicitando
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.picture_as_pdf),
                label: Text(
                  provider.solicitando ? "Generando..." : "Generar reporte",
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
