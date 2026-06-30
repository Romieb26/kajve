import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/qr_provider.dart';

class ScanButton extends StatelessWidget {
  const ScanButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<QrProvider>(
      builder: (context, provider, child) {
        return FilledButton.icon(
          onPressed: provider.procesando
              ? null
              : () {
            provider.reiniciarEscaneo();
          },
          icon: Icon(
            provider.procesando
                ? Icons.hourglass_top
                : Icons.qr_code_scanner,
          ),
          label: Text(
            provider.procesando
                ? "Escaneando..."
                : "Escanear nuevamente",
          ),
        );
      },
    );
  }
}