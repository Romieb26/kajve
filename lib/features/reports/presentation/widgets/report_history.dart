import 'package:flutter/material.dart';

import '../providers/report_provider.dart';
import '../widgets/report_item.dart';

class ReportHistory extends StatelessWidget {
  final ReportProvider provider;

  const ReportHistory({
    super.key,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.folder_open_outlined, color: theme.colorScheme.primary),
            const SizedBox(width: 10),
            Text("Reportes generados", style: theme.textTheme.titleMedium),
          ],
        ),

        const SizedBox(height: 12),

        if (provider.reportes.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Text(
                  "Aún no has generado ningún reporte.",
                  style: theme.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: provider.reportes.length,
            itemBuilder: (context, index) {
              return ReportItem(
                reporte: provider.reportes[index],
              );
            },
          ),
      ],
    );
  }
}