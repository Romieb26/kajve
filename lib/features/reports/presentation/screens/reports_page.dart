import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../shared/widgets/app_drawer.dart';

import '../providers/report_provider.dart';
import '../widgets/report_form.dart';
import '../widgets/report_history.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReportProvider>().cargarReportes();
    });
  }

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
