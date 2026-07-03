import 'package:flutter/material.dart';

import '../../core/routes/app_routes.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.brown,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(
                  Icons.coffee,
                  color: Colors.white,
                  size: 48,
                ),
                SizedBox(height: 10),
                Text(
                  "KAJVE",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Sistema Inteligente de Secado",
                  style: TextStyle(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),

          _item(
            context,
            icon: Icons.dashboard,
            title: "Dashboard",
            route: AppRoutes.dashboard,
          ),

          _item(
            context,
            icon: Icons.agriculture,
            title: "Lotes",
            route: AppRoutes.lots,
          ),

          _item(
            context,
            icon: Icons.add_box,
            title: "Crear Lote",
            route: AppRoutes.createLot,
          ),

          _item(
            context,
            icon: Icons.monitor_heart,
            title: "Monitoreo",
            route: AppRoutes.lotDetail,
          ),

          _item(
            context,
            icon: Icons.qr_code_scanner,
            title: "Escanear QR",
            route: AppRoutes.qr,
          ),

          _item(
            context,
            icon: Icons.show_chart,
            title: "Predicciones",
            route: AppRoutes.prediction,
          ),

          _item(
            context,
            icon: Icons.sensors,
            title: "Tiempo Real",
            route: AppRoutes.realtime,
          ),

          /// NUEVO MÓDULO
          _item(
            context,
            icon: Icons.sensors_outlined,
            title: "Sensores",
            route: AppRoutes.sensors,
          ),

          _item(
            context,
            icon: Icons.history,
            title: "Historial",
            route: AppRoutes.history,
          ),

          _item(
            context,
            icon: Icons.warning_amber,
            title: "Alertas",
            route: AppRoutes.alerts,
          ),

          _item(
            context,
            icon: Icons.description,
            title: "Reportes",
            route: AppRoutes.reports,
          ),

          _item(
            context,
            icon: Icons.person,
            title: "Perfil",
            route: AppRoutes.profile,
          ),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Cerrar sesión"),
            onTap: () {
              Navigator.pushReplacementNamed(
                context,
                AppRoutes.login,
              );
            },
          ),
        ],
      ),
    );
  }

  static Widget _item(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String route,
      }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        Navigator.pop(context);

        Navigator.pushReplacementNamed(
          context,
          route,
        );
      },
    );
  }
}