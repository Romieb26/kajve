import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/prediction_provider.dart';
import '../widgets/ metric_card.dart';
import '../widgets/prediction_card.dart';
import '../widgets/recommendation_card.dart';

class PredictionPage extends StatelessWidget {
  const PredictionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PredictionProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xffB56A1F),

      appBar: AppBar(
        backgroundColor: const Color(0xff6A3C18),
        title: const Text("Predicción del Secado"),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [

            PredictionCard(provider: provider),

            const SizedBox(height:20),

            MetricCard(
              titulo: "Tiempo restante",
              valor: provider.tiempoRestante,
              icono: Icons.schedule,
            ),

            const SizedBox(height:15),

            MetricCard(
              titulo: "Fecha estimada",
              valor: provider.fechaEstimada,
              icono: Icons.calendar_today,
            ),

            const SizedBox(height:15),

            MetricCard(
              titulo: "Calidad esperada",
              valor: provider.calidadEsperada,
              icono: Icons.workspace_premium,
            ),

            const SizedBox(height:20),

            RecommendationCard(provider: provider),

          ],
        ),
      ),
    );
  }
}