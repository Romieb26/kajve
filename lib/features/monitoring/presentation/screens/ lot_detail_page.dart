import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/monitoring_provider.dart';
import '../widgets/ history_button.dart';
import '../widgets/ info_card.dart';
import '../widgets/qr_card.dart';

class LotDetailPage extends StatelessWidget {
  const LotDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MonitoringProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFB86A1B),

      appBar: AppBar(
        backgroundColor: const Color(0xFF6D3A1C),
        elevation: 0,
        title: Text(provider.nombreLote),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person,color: Colors.grey),
            ),
          )
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            InfoCard(provider: provider),

            const SizedBox(height:20),

            const QrCard(),

            const SizedBox(height:20),

            const HistoryButton(),

          ],
        ),
      ),
    );
  }
}