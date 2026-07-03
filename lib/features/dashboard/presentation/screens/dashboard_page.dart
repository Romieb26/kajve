import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../shared/widgets/app_drawer.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

import '../providers/dashboard_provider.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/dashboard_card.dart';
import '../widgets/summary_card.dart';
import '../widgets/recent_prediction_card.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    context.read<DashboardProvider>().loadDashboard();
  }

  String _formatFecha(DateTime fecha) {
    final dia = fecha.day.toString().padLeft(2, '0');
    final mes = fecha.month.toString().padLeft(2, '0');
    return "$dia/$mes/${fecha.year}";
  }

  @override
  Widget build(BuildContext context) {
    final nombreUsuario =
        context.watch<AuthProvider>().usuario?.nombreCompleto ?? "Bienvenido";

    return Scaffold(
      drawer: const AppDrawer(),

      appBar: AppBar(
        title: const Text("Dashboard"),
        centerTitle: true,
      ),

      body: Consumer<DashboardProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading && provider.data == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (provider.errorMessage != null && provider.data == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.cloud_off,
                      size: 48,
                      color: Colors.grey,
                    ),

                    const SizedBox(height: 12),

                    Text(
                      provider.errorMessage!,
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 16),

                    FilledButton(
                      onPressed: () => provider.loadDashboard(),
                      child: const Text("Reintentar"),
                    ),
                  ],
                ),
              ),
            );
          }

          final data = provider.data;

          if (data == null) {
            return const SizedBox.shrink();
          }

          final prediccion = data.ultimaPrediccion;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// Header
                DashboardHeader(
                  nombre: nombreUsuario,
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

                  children: [

                    SummaryCard(
                      titulo: "Lotes",
                      valor: data.totalLotes.toString(),
                      icono: Icons.agriculture,
                    ),

                    SummaryCard(
                      titulo: "Alertas",
                      valor: data.alertasSinAtender.toString(),
                      icono: Icons.warning,
                    ),

                    SummaryCard(
                      titulo: "Reportes",
                      valor: data.totalReportes.toString(),
                      icono: Icons.picture_as_pdf,
                    ),

                    SummaryCard(
                      titulo: "Sensores",
                      valor: data.totalSensores.toString(),
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

                if (prediccion != null)
                  RecentPredictionCard(
                    lote: prediccion.nombreLote,
                    estado: prediccion.calidadEstimada,
                    fecha: _formatFecha(prediccion.fechaPrediccion),
                  )
                else
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        "Sin predicciones recientes",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
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
          );
        },
      ),
    );
  }
}
