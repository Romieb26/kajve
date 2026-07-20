//lib/shared/models/app_drawer.dart
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return NavigationDrawer(
      selectedIndex: 0,
      onDestinationSelected: (index) {
        Navigator.pop(context);

        // Aquí posteriormente agregaremos la navegación
      },
      children: const [

        Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            "KAJVE",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        NavigationDrawerDestination(
          icon: Icon(Icons.dashboard_outlined),
          selectedIcon: Icon(Icons.dashboard),
          label: Text("Dashboard"),
        ),

        NavigationDrawerDestination(
          icon: Icon(Icons.agriculture_outlined),
          selectedIcon: Icon(Icons.agriculture),
          label: Text("Lotes"),
        ),

        NavigationDrawerDestination(
          icon: Icon(Icons.monitor_heart_outlined),
          selectedIcon: Icon(Icons.monitor_heart),
          label: Text("Monitoreo"),
        ),

        NavigationDrawerDestination(
          icon: Icon(Icons.analytics_outlined),
          selectedIcon: Icon(Icons.analytics),
          label: Text("Predicciones"),
        ),

        NavigationDrawerDestination(
          icon: Icon(Icons.history),
          label: Text("Historial"),
        ),

        NavigationDrawerDestination(
          icon: Icon(Icons.warning_amber_outlined),
          selectedIcon: Icon(Icons.warning),
          label: Text("Alertas"),
        ),

        NavigationDrawerDestination(
          icon: Icon(Icons.description_outlined),
          selectedIcon: Icon(Icons.description),
          label: Text("Reportes"),
        ),

        NavigationDrawerDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: Text("Perfil"),
        ),
      ],
    );
  }
}