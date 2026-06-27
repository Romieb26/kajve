import 'package:flutter/material.dart';

// Dashboard
import 'features/dashboard/presentation/screens/dashboard_page.dart';

// Auth
import 'features/auth/presentation/screens/login_page.dart';

// Lotes
import 'features/lots/presentation/screens/ lots_page.dart';
import 'features/lots/presentation/screens/create_lot_page.dart';

// Monitoreo
import 'features/monitoring/presentation/screens/ lot_detail_page.dart';

// QR
import 'features/qr/presentation/screens/scan_qr_page.dart';

// Predicciones
import 'features/predictions/presentation/screens/prediction_page.dart';

// Tiempo Real
import 'features/realtime/presentation/screens/realtime_page.dart';

// Historial
import 'features/ history/presentation/screens/history_page.dart';
// Alertas
import 'features/alerts/presentation/screens/alerts_page.dart';

// Reportes

import 'features/reports/ presentation/screens/reports_page.dart';

// Perfil
import 'features/profile/presentation/screens/profile_page.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("KAJVE - Vistas"),
        centerTitle: true,
      ),

      body: ListView(
        children: [

          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              "Pantallas del proyecto",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text("Dashboard"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const DashboardPage(),
                ),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.login),
            title: const Text("Login"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const LoginPage(),
                ),
              );
            },
          ),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.list_alt),
            title: const Text("Lista de Lotes"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const LotsPage(),
                ),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.add_box),
            title: const Text("Crear Lote"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CreateLotPage(),
                ),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text("Detalle del Lote"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const LotDetailPage(),
                ),
              );
            },
          ),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.qr_code_scanner),
            title: const Text("Escanear QR"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ScanQrPage(),
                ),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.show_chart),
            title: const Text("Predicciones"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const PredictionPage(),
                ),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.monitor_heart),
            title: const Text("Monitoreo en Tiempo Real"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const RealtimePage(),
                ),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.history),
            title: const Text("Historial"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const HistoryPage(),
                ),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.warning_amber),
            title: const Text("Alertas"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AlertsPage(),
                ),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.description),
            title: const Text("Reportes"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ReportsPage(),
                ),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("Perfil"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ProfilePage(),
                ),
              );
            },
          ),

          const SizedBox(height: 20),

        ],
      ),
    );
  }
}