//lib/features/monitoring/presentation/screens/Iot_detail_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../shared/widgets/app_drawer.dart';

import '../providers/monitoring_provider.dart';

import '../widgets/info_card.dart';
import '../widgets/environment_card.dart';
import '../widgets/history_button.dart';
import '../widgets/resumen_lote_card.dart';

class LotDetailPage extends StatefulWidget {
  const LotDetailPage({super.key});

  @override
  State<LotDetailPage> createState() => _LotDetailPageState();
}

class _LotDetailPageState extends State<LotDetailPage> {
  int? _loteId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final arguments = ModalRoute.of(context)?.settings.arguments;
    _loteId = arguments is int ? arguments : null;

    final loteId = _loteId;
    if (loteId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<MonitoringProvider>().cargarDatos(loteId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final loteId = _loteId;

    return Scaffold(
      drawer: const AppDrawer(),

      appBar: AppBar(
        title: Text(loteId != null ? "Lote #$loteId" : "Detalle del lote"),
        centerTitle: true,
      ),

      body: loteId == null
          ? const _MensajeCentrado(
              icono: Icons.error_outline,
              mensaje: "No se especificó el lote a mostrar.",
            )
          : Consumer<MonitoringProvider>(
              builder: (context, provider, child) {
                // El resumen (ws-gateway/Postgres) no depende de
                // /lotes/{id}/estadisticas (api-mobile): si ese endpoint
                // sigue caído pero el resumen sí cargó, se muestra igual
                // en vez de bloquear toda la pantalla con un error.
                final hayAlgoQueMostrar =
                    provider.estadisticas != null || provider.resumen != null;

                if (provider.isLoading && !hayAlgoQueMostrar) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (provider.errorMessage != null && !hayAlgoQueMostrar) {
                  return _MensajeCentrado(
                    icono: Icons.cloud_off,
                    mensaje: provider.errorMessage!,
                    onReintentar: () => provider.cargarDatos(loteId),
                  );
                }

                final estadisticas = provider.estadisticas;

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [

                      /// Resumen de todo el lote (siempre se intenta
                      /// mostrar, incluso si lo de abajo no cargó).
                      ResumenLoteCard(resumen: provider.resumen),

                      const SizedBox(height: 20),

                      if (estadisticas != null) ...[
                        /// Información general
                        InfoCard(estadisticas: estadisticas),

                        const SizedBox(height: 20),

                        /// Condiciones ambientales
                        EnvironmentCard(estadisticas: estadisticas),

                        const SizedBox(height: 20),
                      ],

                      if (provider.lecturas.isEmpty) ...[
                        const Card(
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Text(
                              "Sin lecturas registradas aún",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],

                      /// Historial
                      HistoryButton(loteId: loteId),

                    ],
                  ),
                );
              },
            ),
    );
  }
}

class _MensajeCentrado extends StatelessWidget {
  final IconData icono;
  final String mensaje;
  final VoidCallback? onReintentar;

  const _MensajeCentrado({
    required this.icono,
    required this.mensaje,
    this.onReintentar,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icono, size: 48, color: Colors.grey),
            const SizedBox(height: 12),
            Text(mensaje, textAlign: TextAlign.center),
            if (onReintentar != null) ...[
              const SizedBox(height: 16),
              FilledButton(
                onPressed: onReintentar,
                child: const Text("Reintentar"),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
