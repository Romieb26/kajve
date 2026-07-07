import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/lot_provider.dart';

class CreateLotForm extends StatelessWidget {
  const CreateLotForm({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LotProvider>(context);
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.assignment_outlined, color: theme.colorScheme.primary),
                const SizedBox(width: 10),
                Text("Datos del lote", style: theme.textTheme.titleMedium),
              ],
            ),

            const SizedBox(height: 20),

            TextField(
              controller: provider.nombreController,
              decoration: InputDecoration(
                labelText: "Nombre del lote",
                prefixIcon: const Icon(Icons.badge_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: provider.variedadController,
              decoration: InputDecoration(
                labelText: "Tipo de café",
                prefixIcon: const Icon(Icons.coffee_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: provider.pesoController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                labelText: "Peso (kg)",
                prefixIcon: const Icon(Icons.scale_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 15),

            DropdownButtonFormField<String>(
              initialValue: provider.tipoProceso,
              decoration: InputDecoration(
                labelText: "Tipo de proceso",
                prefixIcon: const Icon(Icons.science_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: const [
                DropdownMenuItem(value: "lavado", child: Text("Lavado")),
                DropdownMenuItem(value: "honey", child: Text("Honey")),
                DropdownMenuItem(value: "natural", child: Text("Natural")),
              ],
              onChanged: provider.seleccionarTipoProceso,
            ),

            const SizedBox(height: 15),

            TextField(
              controller: provider.ubicacionController,
              decoration: InputDecoration(
                labelText: "Ubicación",
                prefixIcon: const Icon(Icons.location_on_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
