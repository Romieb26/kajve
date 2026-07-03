import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../shared/widgets/app_drawer.dart';

import '../providers/monitoring_provider.dart';

import '../widgets/info_card.dart';
import '../widgets/drying_status_card.dart';
import '../widgets/environment_card.dart';
import '../widgets/qr_card.dart';
import '../widgets/history_button.dart';

class LotDetailPage extends StatelessWidget {
  const LotDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MonitoringProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          drawer: const AppDrawer(),

          appBar: AppBar(
            title: Text(provider.nombreLote),
            centerTitle: true,
          ),

          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [

                /// Información general
                InfoCard(
                  provider: provider,
                ),

                const SizedBox(height: 20),

                /// Estado del secado
                DryingStatusCard(
                  estado: provider.estadoSecado,
                  color: provider.colorEstado,
                ),

                const SizedBox(height: 20),

                /// Condiciones ambientales
                EnvironmentCard(
                  provider: provider,
                ),

                const SizedBox(height: 20),

                /// Código QR
                const QrCard(),

                const SizedBox(height: 20),

                /// Historial
                const HistoryButton(),

              ],
            ),
          ),
        );
      },
    );
  }
}