import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/widgets/custom_dialog.dart';
import '../../domain/entities/alerta_entity.dart';
import '../providers/alerts_provider.dart';
import '../widgets/alert_card.dart';
import '../widgets/alert_filter.dart';

class AlertsPage extends ConsumerStatefulWidget {
  const AlertsPage({super.key});

  @override
  ConsumerState<AlertsPage> createState() => _AlertsPageState();
}

class _AlertsPageState extends ConsumerState<AlertsPage> {
  int? _loteId;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final arguments = ModalRoute.of(context)?.settings.arguments;
      final loteId = arguments is int ? arguments : null;

      if (!mounted) return;
      setState(() => _loteId = loteId);

      if (loteId != null) {
        ref.read(alertsControllerProvider.notifier).cargarDatos(loteId);
      }
    });
  }

  void _confirmarAtender(BuildContext context, AlertaEntity alert) {
    CustomDialog.confirm(
      context: context,
      title: "Atender alerta",
      content: '¿Marcar "${alert.tipoAlerta}" como atendida?',
      onConfirm: () async {
        final controller = ref.read(alertsControllerProvider.notifier);
        await controller.atenderAlerta(alert.idAlerta);

        if (!context.mounted) return;
        final errorMessage = ref.read(alertsControllerProvider).errorMessage;
        if (errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage)),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final loteId = _loteId;
    final state = ref.watch(alertsControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Alertas"),
        centerTitle: true,
      ),

      body: loteId == null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  "No se especificó el lote a mostrar.",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            )
          : _buildBody(context, state, loteId),
    );
  }

  Widget _buildBody(BuildContext context, AlertsState state, int loteId) {
    final theme = Theme.of(context);

    if (state.isLoading && state.alertas.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.errorMessage != null && state.alertas.isEmpty) {
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
                onPressed: () => ref
                    .read(alertsControllerProvider.notifier)
                    .cargarDatos(loteId),
                child: const Text("Reintentar"),
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [

          /// Filtros
          AlertFilter(
            state: state,
            controller: ref.read(alertsControllerProvider.notifier),
          ),

          const SizedBox(height: 20),

          /// Lista de alertas
          Expanded(
            child: state.alertas.isEmpty
                ? Center(
                    child: Text(
                      "No hay alertas para este lote",
                      style: theme.textTheme.bodyMedium,
                    ),
                  )
                : ListView.builder(
                    itemCount: state.alertas.length,
                    itemBuilder: (context, index) {
                      final alert = state.alertas[index];
                      return AlertCard(
                        alert: alert,
                        onAtender: () => _confirmarAtender(context, alert),
                      );
                    },
                  ),
          ),

        ],
      ),
    );
  }
}
