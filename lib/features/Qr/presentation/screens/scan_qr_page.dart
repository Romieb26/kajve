import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/qr_provider.dart';
import '../ widgets/ scanner_overlay.dart';
import '../ widgets/bottom_navigation.dart';

class ScanQrPage extends StatelessWidget {
  const ScanQrPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<QrProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: const Color(0xFFB86A1B),

          appBar: AppBar(
            backgroundColor: const Color(0xFF6D3A1C),
            elevation: 0,
            title: const Text("Escanear QR"),
            actions: [
              IconButton(
                icon: Icon(
                  provider.flash
                      ? Icons.flash_on
                      : Icons.flash_off,
                ),
                onPressed: provider.toggleFlash,
              ),
              const Padding(
                padding: EdgeInsets.only(right: 12),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person),
                ),
              )
            ],
          ),

          body: const Column(
            children: [
              Expanded(
                child: Center(
                  child: ScannerOverlay(),
                ),
              ),

              BottomNavigation(),
            ],
          ),
        );
      },
    );
  }
}