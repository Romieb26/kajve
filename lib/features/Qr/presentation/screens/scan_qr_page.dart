import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../shared/widgets/app_drawer.dart';

import '../providers/qr_provider.dart';
import '../widgets/camera_scanner.dart';
import '../widgets/scan_button.dart';
import '../widgets/scan_result_card.dart';

class ScanQrPage extends StatelessWidget {
  const ScanQrPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<QrProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          drawer: const AppDrawer(),

          appBar: AppBar(
            title: const Text("Escanear QR"),
            centerTitle: true,
            actions: [
              IconButton(
                icon: Icon(
                  provider.flash
                      ? Icons.flash_on
                      : Icons.flash_off,
                ),
                onPressed: provider.toggleFlash,
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
                    child: CameraScanner(
                      flash: provider.flash,
                      onDetect: (codigo) {
                        provider.detectarCodigo(
                          context,
                          codigo,
                        );
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                const ScanButton(),

                const SizedBox(height: 20),

                ScanResultCard(
                  provider: provider,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}