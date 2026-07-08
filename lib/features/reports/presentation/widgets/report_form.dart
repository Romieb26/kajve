import 'package:flutter/material.dart';

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
              controller: provider.loteController,
              decoration: InputDecoration(
                labelText: "Seleccionar lote",
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

            const SizedBox(height: 15),

            TextField(
              readOnly: true,
              onTap: () => provider.seleccionarFecha(context),
              decoration: InputDecoration(
                labelText: provider.fechaSeleccionada == null
                    ? "Fecha inicial"
                    : "${provider.fechaSeleccionada!.day}/${provider.fechaSeleccionada!.month}/${provider.fechaSeleccionada!.year}",
                prefixIcon: const Icon(Icons.calendar_today_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: provider.generarReporte,
                icon: const Icon(Icons.picture_as_pdf),
                label: const Text("Generar reporte"),
              ),
            ),

          ],
        ),
      ),
    );
  }
}