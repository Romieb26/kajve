import 'package:flutter/material.dart';

import '../../../../core/routes/ app_routes.dart';
import '../../../../shared/widgets/app_drawer.dart';

import '../widgets/dashboard_header.dart';
import '../widgets/dashboard_card.dart';
import '../widgets/summary_card.dart';
import '../widgets/recent_prediction_card.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),

      appBar: AppBar(
        title: const Text("Dashboard"),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// Header
            const DashboardHeader(
              nombre: "Katherine",
            ),

            const SizedBox(height: 25),

            const Text(
              "Resumen",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 1.15,

              children: const [

                SummaryCard(
                  titulo: "Lotes",
                  valor: "18",
                  icono: Icons.agriculture,
                ),

                SummaryCard(
                  titulo: "Alertas",
                  valor: "2",
                  icono: Icons.warning,
                ),

                SummaryCard(
                  titulo: "Reportes",
                  valor: "10",
                  icono: Icons.picture_as_pdf,
                ),

                SummaryCard(
                  titulo: "Sensores",
                  valor: "6",
                  icono: Icons.sensors,
                ),

              ],
            ),

            const SizedBox(height: 30),

            const Text(
              "Predicciones recientes",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            const RecentPredictionCard(
              lote: "Lote Norte",
              estado: "Secado óptimo",
              fecha: "05/08/2026",
            ),

            const RecentPredictionCard(
              lote: "Lote Centro",
              estado: "Riesgo de humedad",
              fecha: "04/08/2026",
            ),

            const SizedBox(height: 30),

            const Text(
              "Accesos rápidos",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 1.25,

              children: [

                DashboardCard(
                  titulo: "Lotes",
                  icono: Icons.agriculture,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.lots,
                    );
                  },
                ),

                DashboardCard(
                  titulo: "Escanear QR",
                  icono: Icons.qr_code_scanner,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.qr,
                    );
                  },
                ),

                DashboardCard(
                  titulo: "Predicciones",
                  icono: Icons.show_chart,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.prediction,
                    );
                  },
                ),

                DashboardCard(
                  titulo: "Tiempo Real",
                  icono: Icons.monitor_heart,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.realtime,
                    );
                  },
                ),

                DashboardCard(
                  titulo: "Reportes",
                  icono: Icons.picture_as_pdf,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.reports,
                    );
                  },
                ),

                DashboardCard(
                  titulo: "Perfil",
                  icono: Icons.person,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.profile,
                    );
                  },
                ),

              ],
            ),

          ],
        ),
      ),
    );
  }
}