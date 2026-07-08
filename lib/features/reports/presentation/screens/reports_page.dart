import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../shared/widgets/app_drawer.dart';

import '../providers/report_provider.dart';
import '../widgets/report_form.dart';
import '../widgets/report_history.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ReportProvider>(context);

    return Scaffold(
      drawer: const AppDrawer(),

      appBar: AppBar(
        title: const Text("Generar Reportes"),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            ReportForm(provider: provider),

            const SizedBox(height: 20),

            ReportHistory(provider: provider),

          ],
        ),
      ),
    );
  }
}