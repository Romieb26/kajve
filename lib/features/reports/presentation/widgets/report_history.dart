import 'package:flutter/material.dart';

import '../providers/report_provider.dart';
import '../widgets/report_item.dart';

class ReportHistory extends StatelessWidget {
  final ReportState state;
  final ReportController controller;

  const ReportHistory({
    super.key,
    required this.state,
    required this.controller,
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

        _buildBody(theme),
      ],
    );
  }

  Widget _buildBody(ThemeData theme) {
    if (state.isLoading && state.reportes.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.errorMessage != null && state.reportes.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.cloud_off, size: 40, color: theme.textTheme.bodySmall?.color),
              const SizedBox(height: 12),
              Text(
                state.errorMessage!,
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: controller.cargarReportes,
                child: const Text("Reintentar"),
              ),
            ],
          ),
        ),
      );
    }

    if (state.reportes.isEmpty) {
      return Card(
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
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: state.reportes.length,
      itemBuilder: (context, index) {
        return ReportItem(
          reporte: state.reportes[index],
          state: state,
          controller: controller,
        );
      },
    );
  }
}
