import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/widgets/lote_selector_sheet.dart';
import '../providers/report_provider.dart';

class ReportForm extends ConsumerWidget {
  const ReportForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final provider = ref.watch(reportControllerProvider);
    final controller = ref.read(reportControllerProvider.notifier);

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
                ref,
                onSelected: controller.seleccionarLote,
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
              items: tiposReporte.map((tipo) {
                return DropdownMenuItem(
                  value: tipo,
                  child: Text(tipo),
                );
              }).toList(),
              onChanged: controller.seleccionarTipo,
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
                  onSelected: (_) => controller.seleccionarFormato("pdf"),
                ),
                ChoiceChip(
                  label: const Text("Excel"),
                  selected: provider.formato == "excel",
                  onSelected: (_) => controller.seleccionarFormato("excel"),
                ),
              ],
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: provider.solicitando
                    ? null
                    : () => controller.generarReporte(context),
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

            const SizedBox(height: 10),

            /// Reporte narrativo (NLG): texto generado al momento por
            /// microservicioMLL (NLP/generar_reporte.py) a partir de alertas,
            /// predicciones y recomendaciones del lote seleccionado arriba.
            /// No es un archivo -- se muestra directo en un diálogo.
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: provider.cargandoNarrativo
                    ? null
                    : () => _verReporteNarrativo(context, ref),
                icon: provider.cargandoNarrativo
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.auto_awesome),
                label: Text(
                  provider.cargandoNarrativo
                      ? "Generando reporte narrativo..."
                      : "Ver reporte narrativo (IA)",
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }

  Future<void> _verReporteNarrativo(
    BuildContext context,
    WidgetRef ref,
  ) async {
    await ref.read(reportControllerProvider.notifier).cargarReporteNarrativo(context);
    if (!context.mounted) return;

    final state = ref.read(reportControllerProvider);
    final reporte = state.reporteNarrativo;
    final error = state.errorNarrativo;
    if (reporte == null && error == null) return; // faltaba seleccionar lote

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("Reporte narrativo (IA)"),
        content: SingleChildScrollView(
          child: Text(
            error ?? reporte!.reporteTexto,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text("Cerrar"),
          ),
        ],
      ),
    );
  }
}
