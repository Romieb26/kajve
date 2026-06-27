import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../shared/widgets/app_bottom_navigation.dart';
import '../providers/ history_provider.dart';
import '../widgets/history_filters.dart';
import '../widgets/history_table.dart';
import '../widgets/search_history.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HistoryProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xffB56A1F),

      appBar: AppBar(
        backgroundColor: const Color(0xff6A3C18),
        title: const Text("Historial"),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            SearchHistory(provider: provider),

            const SizedBox(height: 15),

            const HistoryFilters(),

            const SizedBox(height: 20),

            Expanded(
              child: HistoryTable(
                provider: provider,
              ),
            ),

          ],
        ),
      ),

      bottomNavigationBar: const AppBottomNavigation(
        currentIndex: 3,
      ),
    );
  }
}