import 'package:flutter/material.dart';

class HistoryButton extends StatelessWidget {
  const HistoryButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: () {
        // TODO: Navegar al historial del lote
      },
      icon: const Icon(Icons.history),
      label: const Text("Ver historial"),
    );
  }
}