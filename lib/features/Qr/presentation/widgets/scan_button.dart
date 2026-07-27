import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/qr_provider.dart';

class ScanButton extends ConsumerWidget {
  const ScanButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(qrControllerProvider);
    final controller = ref.read(qrControllerProvider.notifier);

    return FilledButton.icon(
      onPressed: state.procesando
          ? null
          : () {
        controller.reiniciarEscaneo();
      },
      icon: Icon(
        state.procesando
            ? Icons.hourglass_top
            : Icons.qr_code_scanner,
      ),
      label: Text(
        state.procesando
            ? "Escaneando..."
            : "Escanear nuevamente",
      ),
    );
  }
}
