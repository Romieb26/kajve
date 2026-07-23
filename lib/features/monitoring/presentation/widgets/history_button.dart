//lib/features/monitoring/presentation/widgets/history_button.dart
import 'package:flutter/material.dart';

import '../../../../core/routes/app_routes.dart';

class HistoryButton extends StatelessWidget {
  final int loteId;

  const HistoryButton({super.key, required this.loteId});

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: () {
        Navigator.pushNamed(context, AppRoutes.history, arguments: loteId);
      },
      icon: const Icon(Icons.history),
      label: const Text("Ver historial"),
    );
  }
}