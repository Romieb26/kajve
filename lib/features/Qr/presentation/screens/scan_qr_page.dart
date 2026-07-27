import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/widgets/app_drawer.dart';

import '../providers/qr_provider.dart';
import '../widgets/camera_scanner.dart';
import '../widgets/scan_button.dart';
import '../widgets/scan_result_card.dart';

class ScanQrPage extends ConsumerWidget {
  const ScanQrPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(qrControllerProvider);
    final controller = ref.read(qrControllerProvider.notifier);

    return Scaffold(
      drawer: const AppDrawer(),

      appBar: AppBar(
        title: const Text("Escanear QR"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              state.flash
                  ? Icons.flash_on
                  : Icons.flash_off,
            ),
            onPressed: controller.toggleFlash,
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            /// Cámara
            SizedBox(
              height: 350,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  children: [
                    CameraScanner(
                      flash: state.flash,
                      paused: state.procesando,
                      onDetect: (codigo) {
                        controller.detectarCodigo(
                          context,
                          codigo,
                        );
                      },
                    ),

                    if (state.procesando)
                      Container(
                        color: Colors.black54,
                        child: const Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircularProgressIndicator(
                                color: Colors.white,
                              ),
                              SizedBox(height: 12),
                              Text(
                                "Reclamando lote...",
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            const ScanButton(),

            const SizedBox(height: 20),

            ScanResultCard(
              state: state,
            ),
          ],
        ),
      ),
    );
  }
}
