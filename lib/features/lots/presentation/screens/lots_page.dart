import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../shared/widgets/app_drawer.dart';

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
          drawer: const AppDrawer(),

          appBar: AppBar(
            title: const Text("Lista de Lotes"),
            centerTitle: true,
          ),

          floatingActionButton: FloatingActionButton.extended(
            icon: const Icon(Icons.add),
            label: const Text("Nuevo"),
            onPressed: () {
              Navigator.pushNamed(
                context,
                AppRoutes.createLot,
              );
            },
          ),

          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                SearchBarWidget(
                  controller: provider.searchController,
                  onChanged: provider.buscar,
                ),

                const SizedBox(height: 20),

                Expanded(
                  child: ListView.separated(
                    itemCount: provider.lotes.length,
                    separatorBuilder: (_, __) =>
                    const SizedBox(height: 15),
                    itemBuilder: (context, index) {
                      final lote = provider.lotes[index];

                      return GestureDetector(
                        onTap: () {
                          if (lote.id == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Este lote de ejemplo no tiene datos de monitoreo.",
                                ),
                              ),
                            );
                            return;
                          }

                          Navigator.pushNamed(
                            context,
                            AppRoutes.lotDetail,
                            arguments: lote.id,
                          );
                        },
                        child: LotCard(
                          nombre: lote.nombre,
                          fecha: lote.fecha,
                          estado: lote.estado,
                          colorEstado: lote.colorEstado,
                        ),
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