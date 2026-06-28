import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/alerts_provider.dart';
import '../widgets/ alert_card.dart';
import '../widgets/alert_filter.dart';

class AlertsPage extends StatelessWidget {
  const AlertsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AlertsProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: const Color(0xffB86A1B),

          appBar: AppBar(
            backgroundColor: const Color(0xff6D3A1C),
            title: const Text("Alertas"),
            centerTitle: true,
          ),

          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [

                /// Filtros
                AlertFilter(provider: provider),

                const SizedBox(height: 20),

                /// Lista de alertas
                Expanded(
                  child: ListView.builder(
                    itemCount: provider.alertas.length,
                    itemBuilder: (context, index) {
                      final alert = provider.alertas[index];
                      return AlertCard(alert: alert);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}