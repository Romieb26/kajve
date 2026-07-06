import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../shared/widgets/app_drawer.dart';

import '../providers/monitoring_provider.dart';

import '../widgets/info_card.dart';
import '../widgets/drying_status_card.dart';
import '../widgets/environment_card.dart';
import '../widgets/qr_card.dart';
import '../widgets/history_button.dart';

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
                if (provider.isLoading && provider.estadisticas == null) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (provider.errorMessage != null &&
                    provider.estadisticas == null) {
                  return _MensajeCentrado(
                    icono: Icons.cloud_off,
                    mensaje: provider.errorMessage!,
                    onReintentar: () => provider.cargarDatos(loteId),
                  );
                }

                final estadisticas = provider.estadisticas;

                if (estadisticas == null) {
                  return const Center(child: CircularProgressIndicator());
                }

                final alertasCriticas = estadisticas.alertasCriticas;
                final alertasSinAtender = estadisticas.alertasSinAtender;

                final String estado;
                final Color color;

                if (alertasCriticas > 0) {
                  estado = "Riesgo";
                  color = Colors.red;
                } else if (alertasSinAtender > 0) {
                  estado = "En proceso";
                  color = Colors.orange;
                } else {
                  estado = "Óptimo";
                  color = Colors.green;
                }

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [

                      /// Información general
                      InfoCard(estadisticas: estadisticas),

                      const SizedBox(height: 20),

                      /// Estado del secado
                      DryingStatusCard(
                        estado: estado,
                        color: color,
                      ),

                      const SizedBox(height: 20),

                      /// Condiciones ambientales
                      EnvironmentCard(estadisticas: estadisticas),

                      if (provider.lecturas.isEmpty) ...[
                        const SizedBox(height: 20),
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
                      ],

                      const SizedBox(height: 20),

                      /// Código QR
                      const QrCard(),

                      const SizedBox(height: 20),

                      /// Historial
                      const HistoryButton(),

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
