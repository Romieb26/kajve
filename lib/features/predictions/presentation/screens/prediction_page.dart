import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../shared/widgets/app_drawer.dart';

import '../providers/prediction_provider.dart';

import '../widgets/metric_card.dart';
import '../widgets/prediction_card.dart';
import '../widgets/recommendation_card.dart';
import '../widgets/prediction_chart.dart';
import '../widgets/prediction_history.dart';

class PredictionPage extends StatelessWidget {
  const PredictionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PredictionProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          drawer: const AppDrawer(),

          appBar: AppBar(
            title: const Text("Predicción IA"),
            centerTitle: true,
          ),

          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [

                /// Predicción principal
                PredictionCard(
                  provider: provider,
                ),

                const SizedBox(height: 20),

                /// Tiempo restante
                MetricCard(
                  titulo: "Tiempo restante",
                  valor: provider.tiempoRestante,
                  icono: Icons.schedule,
                ),

                const SizedBox(height: 15),

                /// Fecha estimada
                MetricCard(
                  titulo: "Fecha estimada",
                  valor: provider.fechaEstimada,
                  icono: Icons.calendar_today,
                ),

                const SizedBox(height: 15),

                /// Calidad esperada
                MetricCard(
                  titulo: "Calidad esperada",
                  valor: provider.calidadEsperada,
                  icono: Icons.workspace_premium,
                ),

                const SizedBox(height: 20),

                /// Recomendaciones IA
                RecommendationCard(
                  provider: provider,
                ),

                const SizedBox(height: 20),

                /// Gráfica del avance
                PredictionChart(
                  provider: provider,
                ),

                const SizedBox(height: 20),

                /// Historial de predicciones
                PredictionHistory(
                  provider: provider,
                ),

              ],
            ),
          ),
        );
      },
    );
  }
}