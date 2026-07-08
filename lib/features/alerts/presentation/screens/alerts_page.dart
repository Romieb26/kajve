import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../shared/widgets/custom_dialog.dart';
import '../../domain/entities/alerta_entity.dart';
import '../providers/alerts_provider.dart';
import '../widgets/alert_card.dart';
import '../widgets/alert_filter.dart';

class AlertsPage extends StatefulWidget {
  const AlertsPage({super.key});

  @override
  State<AlertsPage> createState() => _AlertsPageState();
}

class _AlertsPageState extends State<AlertsPage> {
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
        context.read<AlertsProvider>().cargarDatos(loteId);
      }
    });
  }

  void _confirmarAtender(BuildContext context, AlertaEntity alert) {
    CustomDialog.confirm(
      context: context,
      title: "Atender alerta",
      content: '¿Marcar "${alert.tipoAlerta}" como atendida?',
      onConfirm: () async {
        final provider = context.read<AlertsProvider>();
        await provider.atenderAlerta(alert.idAlerta);

        if (!context.mounted) return;
        if (provider.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(provider.errorMessage!)),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final loteId = _loteId;

    return Consumer<AlertsProvider>(
      builder: (context, provider, child) {
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
              : _buildBody(context, provider, loteId),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, AlertsProvider provider, int loteId) {
    final theme = Theme.of(context);

    if (provider.isLoading && provider.alertas.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.errorMessage != null && provider.alertas.isEmpty) {
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
                onPressed: () => provider.cargarDatos(loteId),
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
          AlertFilter(provider: provider),

          const SizedBox(height: 20),

          /// Lista de alertas
          Expanded(
            child: provider.alertas.isEmpty
                ? Center(
                    child: Text(
                      "No hay alertas para este lote",
                      style: theme.textTheme.bodyMedium,
                    ),
                  )
                : ListView.builder(
                    itemCount: provider.alertas.length,
                    itemBuilder: (context, index) {
                      final alert = provider.alertas[index];
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
