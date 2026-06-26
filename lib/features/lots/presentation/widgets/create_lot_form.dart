import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/lot_provider.dart';

class CreateLotForm extends StatelessWidget {
  const CreateLotForm({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LotProvider>(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          TextField(
            controller: provider.nombreController,
            decoration: const InputDecoration(
              labelText: "Nombre del lote",
              border: UnderlineInputBorder(),
            ),
          ),

          const SizedBox(height: 10),

          TextField(
            controller: provider.tipoController,
            decoration: const InputDecoration(
              labelText: "Tipo de café",
              border: UnderlineInputBorder(),
            ),
          ),

          const SizedBox(height: 10),

          TextField(
            controller: provider.fechaController,
            decoration: const InputDecoration(
              labelText: "Fecha de inicio de secado",
              border: UnderlineInputBorder(),
            ),
          ),

          const SizedBox(height: 10),

          TextField(
            controller: provider.ubicacionController,
            decoration: const InputDecoration(
              labelText: "Ubicación",
              border: UnderlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }
}