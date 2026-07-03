import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../shared/widgets/app_drawer.dart';

import '../providers/history_provider.dart';

import '../widgets/search_history.dart';
import '../widgets/history_filters.dart';
import '../widgets/history_table.dart';
import '../widgets/history_statistics.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HistoryProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          drawer: const AppDrawer(),

          appBar: AppBar(
            title: const Text("Historial"),
            centerTitle: true,
          ),

          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [

                SearchHistory(
                  provider: provider,
                ),

                const SizedBox(height: 20),

                const HistoryFilters(),

                const SizedBox(height: 20),

                HistoryTable(
                  provider: provider,
                ),

                const SizedBox(height: 20),

                HistoryStatistics(
                  provider: provider,
                ),

              ],
            ),
          ),
        );
      },
    );
  }
}