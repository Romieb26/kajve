import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/lot_provider.dart';
import '../widgets/lot_card.dart';
import '../widgets/search_bar_widget.dart';

class LotsPage extends StatelessWidget {
  const LotsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LotProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: const Color(0xFFB86A1B),

          appBar: AppBar(
            backgroundColor: const Color(0xFF6D3A1C),
            elevation: 0,
            centerTitle: true,
            title: const Text(
              "Lotes",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: const [
              Padding(
                padding: EdgeInsets.only(right: 15),
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),

          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.black,
            onPressed: () {
              // Navegar a Registrar Lote
            },
            child: const Icon(Icons.add),
          ),

          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [

                /// Buscador
                SearchBarWidget(
                  controller: provider.searchController,
                  onChanged: provider.buscar,
                ),

                const SizedBox(height: 20),

                /// Lista de lotes
                Expanded(
                  child: ListView.separated(
                    itemCount: provider.lotes.length,
                    separatorBuilder: (_, __) =>
                    const SizedBox(height: 15),
                    itemBuilder: (context, index) {
                      final lote = provider.lotes[index];

                      return LotCard(
                        nombre: lote.nombre,
                        fecha: lote.fecha,
                        estado: lote.estado,
                        colorEstado: lote.colorEstado,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}