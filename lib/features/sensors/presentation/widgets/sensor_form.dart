import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/sensor_provider.dart';

class SensorForm extends StatelessWidget {
  const SensorForm({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SensorProvider>(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [

          /// Nombre
          TextField(
            controller: provider.nombreController,
            decoration: const InputDecoration(
              labelText: "Nombre del sensor",
              prefixIcon: Icon(Icons.sensors),
            ),
          ),

          const SizedBox(height: 15),

          /// Tipo
          TextField(
            controller: provider.tipoController,
            decoration: const InputDecoration(
              labelText: "Tipo de sensor",
              prefixIcon: Icon(Icons.category),
            ),
          ),

          const SizedBox(height: 15),

          /// Código
          TextField(
            controller: provider.codigoController,
            decoration: const InputDecoration(
              labelText: "Código",
              prefixIcon: Icon(Icons.qr_code),
            ),
          ),

          const SizedBox(height: 15),

          /// Lote
          TextField(
            controller: provider.loteController,
            decoration: const InputDecoration(
              labelText: "Lote asociado",
              prefixIcon: Icon(Icons.agriculture),
            ),
          ),

          const SizedBox(height: 20),

          SwitchListTile(
            value: provider.conectado,
            onChanged: provider.cambiarEstado,
            title: const Text("Sensor conectado"),
            secondary: const Icon(Icons.wifi),
          ),
        ],
      ),
    );
  }
}