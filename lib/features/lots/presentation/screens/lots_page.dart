import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../shared/widgets/app_drawer.dart';

import '../providers/lot_provider.dart';
import '../widgets/lot_card.dart';
import '../widgets/search_bar_widget.dart';

class LotsPage extends ConsumerStatefulWidget {
  const LotsPage({super.key});

  @override
  ConsumerState<LotsPage> createState() => _LotsPageState();
}

class _LotsPageState extends ConsumerState<LotsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(lotControllerProvider.notifier).cargarLotes();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(lotControllerProvider);
    final controller = ref.read(lotControllerProvider.notifier);

    return Scaffold(
      drawer: const AppDrawer(),

      appBar: AppBar(
        title: const Text("Lista de Lotes"),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SearchBarWidget(
              controller: controller.searchController,
              onChanged: controller.buscar,
            ),

            const SizedBox(height: 20),

            Expanded(
              child: _buildBody(context, state, controller),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, LotState state, LotController controller) {
    if (state.cargandoLotes && state.lotes.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.errorLotes != null && state.lotes.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.cloud_off, size: 48, color: Colors.grey),
              const SizedBox(height: 12),
              Text(state.errorLotes!, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => controller.cargarLotes(),
                child: const Text("Reintentar"),
              ),
            ],
          ),
        ),
      );
    }

    if (state.lotes.isEmpty) {
      return const Center(
        child: Text(
          "No tienes lotes registrados aún.",
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: controller.cargarLotes,
      child: ListView.separated(
        itemCount: state.lotes.length,
        separatorBuilder: (_, _) => const SizedBox(height: 15),
        itemBuilder: (context, index) {
          final lote = state.lotes[index];

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
