import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../shared/widgets/app_drawer.dart';

import '../providers/realtime_provider.dart';

import '../widgets/realtime_header.dart';
import '../widgets/sensor_grid.dart';
import '../widgets/environment_card.dart';
import '../widgets/chart_card.dart';

class RealtimePage extends StatefulWidget {
  const RealtimePage({super.key});

  @override
  State<RealtimePage> createState() => _RealtimePageState();
}

class _RealtimePageState extends State<RealtimePage> {
  int? _loteId;
  bool _inicializado = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_inicializado) return;
    _inicializado = true;

    final arguments = ModalRoute.of(context)?.settings.arguments;
    _loteId = arguments is int ? arguments : null;

    final loteId = _loteId;
    if (loteId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final provider = context.read<RealtimeProvider>();
        provider.cargarDatos(loteId);
        provider.iniciarAutoRefresh(loteId);
      });
    }
  }

  @override
  void dispose() {
    // El provider vive a nivel de app (registrado una sola vez en
    // main.dart), así que si no se detiene aquí el auto-refresco
    // seguiría corriendo en segundo plano tras salir de la pantalla.
    context.read<RealtimeProvider>().detenerAutoRefresh();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loteId = _loteId;

    return Scaffold(
      drawer: const AppDrawer(),

      appBar: AppBar(
        title: const Text("Tiempo Real"),
        centerTitle: true,
      ),

      body: loteId == null
          ? const _MensajeCentrado(
              icono: Icons.error_outline,
              mensaje: "No se especificó el lote a mostrar.",
            )
          : Consumer<RealtimeProvider>(
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

                final ultimaLectura =
                    provider.lecturas.isNotEmpty ? provider.lecturas.last : null;

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [

                      RealtimeHeader(
                        loteId: loteId,
                        estadisticas: provider.estadisticas,
                      ),

                      const SizedBox(height: 20),

                      SensorGrid(ultimaLectura: ultimaLectura),

                      const SizedBox(height: 20),

                      ChartCard(lecturas: provider.lecturas),

                      const SizedBox(height: 20),

                      EnvironmentCard(estadisticas: provider.estadisticas),

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
