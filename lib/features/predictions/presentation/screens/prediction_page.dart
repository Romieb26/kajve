import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../shared/widgets/app_drawer.dart';

import '../providers/prediction_provider.dart';

import '../widgets/metric_card.dart';
import '../widgets/recommendation_card.dart';
import '../widgets/prediction_history.dart';

class PredictionPage extends StatefulWidget {
  const PredictionPage({super.key});

  @override
  State<PredictionPage> createState() => _PredictionPageState();
}

class _PredictionPageState extends State<PredictionPage> {
  int? _loteId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final arguments = ModalRoute.of(context)?.settings.arguments;
    _loteId = arguments is int ? arguments : null;

    final loteId = _loteId;
    if (loteId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<PredictionProvider>().cargarDatos(loteId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final loteId = _loteId;

    return Scaffold(
      drawer: const AppDrawer(),

      appBar: AppBar(
        title: Text(
          loteId != null ? "Predicción IA - Lote #$loteId" : "Predicción IA",
        ),
        centerTitle: true,
      ),

      body: loteId == null
          ? const _MensajeCentrado(
              icono: Icons.error_outline,
              mensaje: "No se especificó el lote a mostrar.",
            )
          : Consumer<PredictionProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading &&
                    provider.predicciones.isEmpty &&
                    provider.recomendaciones.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (provider.errorMessage != null &&
                    provider.predicciones.isEmpty &&
                    provider.recomendaciones.isEmpty) {
                  return _MensajeCentrado(
                    icono: Icons.cloud_off,
                    mensaje: provider.errorMessage!,
                    onReintentar: () => provider.cargarDatos(loteId),
                  );
                }

                final ultimaPrediccion = provider.predicciones.isNotEmpty
                    ? provider.predicciones.last
                    : null;

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [

                      if (ultimaPrediccion != null) ...[

                        /// Tiempo restante
                        MetricCard(
                          titulo: "Tiempo restante",
                          valor:
                              "${ultimaPrediccion.tiempoEstimadoHoras.toStringAsFixed(1)} horas",
                          icono: Icons.schedule,
                        ),

                        const SizedBox(height: 15),

                        /// Última predicción generada
                        MetricCard(
                          titulo: "Última predicción generada",
                          valor: ultimaPrediccion.fechaPrediccion ??
                              "Sin fecha",
                          icono: Icons.calendar_today,
                        ),

                        const SizedBox(height: 15),

                        /// Calidad esperada
                        MetricCard(
                          titulo: "Calidad esperada",
                          valor: ultimaPrediccion.calidadEstimada,
                          icono: Icons.workspace_premium,
                        ),

                        const SizedBox(height: 15),

                        /// Confianza IA — el backend la manda como
                        /// fracción (0-1), se muestra como porcentaje.
                        MetricCard(
                          titulo: "Confianza IA",
                          valor:
                              "${(ultimaPrediccion.confianza * 100).toStringAsFixed(0)}%",
                          icono: Icons.psychology,
                        ),

                        const SizedBox(height: 20),
                      ],

                      /// Recomendaciones IA
                      RecommendationCard(
                        recomendaciones: provider.recomendaciones,
                      ),

                      const SizedBox(height: 20),

                      /// Historial de predicciones
                      PredictionHistory(
                        predicciones: provider.predicciones,
                      ),

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
