import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../shared/widgets/app_drawer.dart';

import '../../../lots/presentation/providers/lot_provider.dart';
import '../providers/history_provider.dart';

import '../widgets/search_history.dart';
import '../widgets/history_filters.dart';
import '../widgets/history_table.dart';
import '../widgets/history_statistics.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
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

  /// Busca el nombre del lote en la caché de LotProvider (sin red). Si
  /// no está cargada todavía (ej. se llegó por QR sin pasar antes por
  /// la lista de lotes), se hace la única llamada extra necesaria.
  Future<void> _preseleccionarLote(int loteId) async {
    final lotProvider = context.read<LotProvider>();
    final historyProvider = context.read<HistoryProvider>();

    var lote = _buscarLote(lotProvider.lotes, loteId);

    if (lote == null && !lotProvider.cargandoLotes) {
      await lotProvider.cargarLotes();
      lote = _buscarLote(lotProvider.lotes, loteId);
    }

    if (!mounted) return;
    historyProvider.seleccionarLotePorId(loteId, nombre: lote?.nombre);
  }

  Lote? _buscarLote(List<Lote> lotes, int loteId) {
    for (final lote in lotes) {
      if (lote.id == loteId) return lote;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HistoryProvider>(
      builder: (context, provider, child) {
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
                HistoryFilters(provider: provider),

                const SizedBox(height: 20),

                _buildContenido(context, provider),

              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildContenido(BuildContext context, HistoryProvider provider) {
    final theme = Theme.of(context);

    if (provider.loteIdSeleccionado == null) {
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

    if (provider.cargando && provider.historial.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.errorMessage != null && provider.historial.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.cloud_off, size: 48, color: theme.textTheme.bodySmall?.color),
              const SizedBox(height: 12),
              Text(
                provider.errorMessage!,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => provider.cargarHistorial(provider.loteIdSeleccionado!),
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
          provider: provider,
        ),

        const SizedBox(height: 20),

        /// Tabla
        HistoryTable(
          provider: provider,
        ),

        const SizedBox(height: 20),

        /// Estadísticas
        HistoryStatistics(
          provider: provider,
        ),
      ],
    );
  }
}
