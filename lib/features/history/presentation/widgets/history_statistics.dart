import 'package:flutter/material.dart';

import '../providers/history_provider.dart';

class HistoryStatistics extends StatelessWidget {
  final HistoryProvider provider;

  const HistoryStatistics({
    super.key,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    final total = provider.historial.length;

    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            Row(
              children: [
                Icon(Icons.insights_outlined, color: theme.colorScheme.primary),
                const SizedBox(width: 10),
                Text("Estadísticas", style: theme.textTheme.titleMedium),
              ],
            ),

            const Divider(height: 30),

            ListTile(
              leading: Icon(Icons.list_alt, color: theme.colorScheme.primary),
              title: const Text("Total de eventos"),
              trailing: Text(
                total.toString(),
                style: theme.textTheme.titleSmall,
              ),
            ),

          ],
        ),
      ),
    );
  }
}