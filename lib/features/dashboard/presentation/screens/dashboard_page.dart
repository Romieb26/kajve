import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../shared/widgets/app_bottom_navigation.dart';
import '../providers/dashboard_provider.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/recent_prediction_card.dart';
import '../widgets/summary_card.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DashboardProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xffF4F1EC),

      appBar: AppBar(
        title: const Text("Dashboard"),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            DashboardHeader(
              nombre: provider.nombreUsuario,
            ),

            const SizedBox(height: 20),

            Row(
              children: [

                Expanded(
                  child: SummaryCard(
                    titulo: "Lotes",
                    valor: provider.lotesActivos.toString(),
                    icono: Icons.agriculture,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: SummaryCard(
                    titulo: "Alertas",
                    valor: provider.alertas.toString(),
                    icono: Icons.warning_amber,
                  ),
                ),

              ],
            ),

            const SizedBox(height: 12),

            SummaryCard(
              titulo: "Predicciones",
              valor: provider.predicciones.toString(),
              icono: Icons.analytics,
            ),

            const SizedBox(height: 25),

            const Text(
              "Últimas predicciones",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            ...provider.ultimasPredicciones.map(
                  (prediccion) => RecentPredictionCard(
                lote: prediccion["lote"],
                estado: prediccion["estado"],
                fecha: prediccion["fecha"],
              ),
            ),

          ],
        ),
      ),

      bottomNavigationBar: const AppBottomNavigation(
        currentIndex: 0,
      ),
    );
  }
}