import 'package:flutter/material.dart';

class ScannerOverlay extends StatelessWidget {
  const ScannerOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      height: 250,
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Icon(
            Icons.qr_code_scanner,
            size: 180,
            color: Colors.black,
          ),

          Positioned(
            top: 20,
            right: 20,
            child: Icon(
              Icons.bug_report,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}