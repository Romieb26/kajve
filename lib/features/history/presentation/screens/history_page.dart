import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/widgets/app_drawer.dart';

import '../../../lots/presentation/providers/lot_provider.dart';
import '../providers/history_provider.dart';

import '../widgets/search_history.dart';
import '../widgets/history_filters.dart';
import '../widgets/history_table.dart';
import '../widgets/history_statistics.dart';

class HistoryPage extends ConsumerStatefulWidget {
  const HistoryPage({super.key});

  @override
  ConsumerState<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends ConsumerState<HistoryPage> {
  bool _argumentoProcesado = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_argumentoProcesado) return;
    _argumentoProcesado = true;

    final arguments = ModalRoute.of(context)?.settings.arguments;
    final loteId = arguments is int ? arguments : null;
    if (loteId == null) return;

    WidgetsBinding.instance.addPostFrameCallback((_) => _preseleccionarLote(loteId));
  }

  /// Busca el nombre del lote en la caché de LotController (sin red). Si
  /// no está cargada todavía (ej. se llegó por QR sin pasar antes por
  /// la lista de lotes), se hace la única llamada extra necesaria.
  Future<void> _preseleccionarLote(int loteId) async {
    final lotController = ref.read(lotControllerProvider.notifier);
    final historyController = ref.read(historyControllerProvider.notifier);

    var lote = _buscarLote(ref.read(lotControllerProvider).lotes, loteId);

    if (lote == null && !ref.read(lotControllerProvider).cargandoLotes) {
      await lotController.cargarLotes();
      lote = _buscarLote(ref.read(lotControllerProvider).lotes, loteId);
    }

    if (!mounted) return;
    historyController.seleccionarLotePorId(loteId, nombre: lote?.nombre);
  }

  Lote? _buscarLote(List<Lote> lotes, int loteId) {
    for (final lote in lotes) {
      if (lote.id == loteId) return lote;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(historyControllerProvider);
    final controller = ref.read(historyControllerProvider.notifier);

    return Scaffold(
      drawer: const AppDrawer(),

      appBar: AppBar(
        title: const Text("Historial"),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            /// Filtros (incluye el selector de lote, que dispara la carga)
            HistoryFilters(state: state, controller: controller),

            const SizedBox(height: 20),

            _buildContenido(context, state, controller),

          ],
        ),
      ),
    );
  }

  Widget _buildContenido(
    BuildContext context,
    HistoryState state,
    HistoryController controller,
  ) {
    final theme = Theme.of(context);

    if (state.loteIdSeleccionado == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            "Selecciona un lote para ver su historial.",
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium,
          ),
        ),
      );
    }

    if (state.cargando && state.historial.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.errorMessage != null && state.historial.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.cloud_off, size: 48, color: theme.textTheme.bodySmall?.color),
              const SizedBox(height: 12),
              Text(
                state.errorMessage!,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => controller.cargarHistorial(state.loteIdSeleccionado!),
                child: const Text("Reintentar"),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [

        /// Buscador
        SearchHistory(
          controller: controller,
        ),

        const SizedBox(height: 20),

        /// Tabla
        HistoryTable(
          state: state,
        ),

        const SizedBox(height: 20),

        /// Estadísticas
        HistoryStatistics(
          state: state,
        ),
      ],
    );
  }
}
