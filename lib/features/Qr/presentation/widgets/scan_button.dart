import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/qr_provider.dart';

class ScanButton extends StatelessWidget {
  const ScanButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: () {
        context.read<QrProvider>().scanQr();
      },

      icon: const Icon(Icons.qr_code_scanner),

      label: const Text("Escanear QR"),
    );
  }
}