import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../shared/widgets/app_bottom_navigation.dart';
import '../providers/alerts_provider.dart';
import '../widgets/ alert_card.dart';


class AlertsPage extends StatelessWidget {
  const AlertsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AlertsProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xffB56A1F),

      appBar: AppBar(
        backgroundColor: const Color(0xff6A3C18),
        title: const Text("Alertas"),
        centerTitle: true,
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: provider.alerts.length,
        itemBuilder: (context, index) {
          return AlertCard(
            alert: provider.alerts[index],
            onPressed: () {
              provider.marcarRevisada(index);
            },
          );
        },
      ),

      bottomNavigationBar: const AppBottomNavigation(
        currentIndex: 2,
      ),
    );
  }
}