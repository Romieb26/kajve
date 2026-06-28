import 'package:flutter/material.dart';

import '../providers/ report_provider.dart';

class ReportForm extends StatelessWidget {
  final ReportProvider provider;

  const ReportForm({
    super.key,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            TextField(
              controller: provider.loteController,
              decoration: const InputDecoration(
                labelText: "Seleccionar lote",
                prefixIcon: Icon(Icons.agriculture),
              ),
            ),

            const SizedBox(height: 15),

            DropdownButtonFormField<String>(
              value: provider.tipoReporte,
              decoration: const InputDecoration(
                labelText: "Tipo de reporte",
                prefixIcon: Icon(Icons.description),
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
                prefixIcon: const Icon(Icons.calendar_today),
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