import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../shared/widgets/app_drawer.dart';

import '../providers/lot_provider.dart';
import '../widgets/lot_card.dart';
import '../widgets/search_bar_widget.dart';

class LotsPage extends StatefulWidget {
  const LotsPage({super.key});

  @override
  State<LotsPage> createState() => _LotsPageState();
}

class _LotsPageState extends State<LotsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LotProvider>().cargarLotes();
    });
  }

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
                  child: _buildBody(context, provider),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, LotProvider provider) {
    if (provider.cargandoLotes && provider.lotes.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.errorLotes != null && provider.lotes.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.cloud_off, size: 48, color: Colors.grey),
              const SizedBox(height: 12),
              Text(provider.errorLotes!, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => provider.cargarLotes(),
                child: const Text("Reintentar"),
              ),
            ],
          ),
        ),
      );
    }

    if (provider.lotes.isEmpty) {
      return const Center(
        child: Text(
          "No tienes lotes registrados aún.",
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: provider.cargarLotes,
      child: ListView.separated(
        itemCount: provider.lotes.length,
        separatorBuilder: (_, __) => const SizedBox(height: 15),
        itemBuilder: (context, index) {
          final lote = provider.lotes[index];

          return ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: InkWell(
              onTap: () {
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
            ),
          );
        },
      ),
    );
  }
}