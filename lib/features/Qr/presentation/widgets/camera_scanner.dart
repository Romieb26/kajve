import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class CameraScanner extends StatefulWidget {
  final Function(String) onDetect;
  final bool flash;

  const CameraScanner({
    super.key,
    required this.onDetect,
    required this.flash,
  });

  @override
  State<CameraScanner> createState() => _CameraScannerState();
}

class _CameraScannerState extends State<CameraScanner> {

  late MobileScannerController controller;

  @override
  void initState() {
    super.initState();

    controller = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      torchEnabled: widget.flash,
    );
  }

  @override
  void didUpdateWidget(covariant CameraScanner oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.flash != oldWidget.flash) {
      controller.toggleTorch();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [

        MobileScanner(
          controller: controller,

          onDetect: (capture) {

            final barcode = capture.barcodes.first;

            final codigo = barcode.rawValue;

            if (codigo != null) {
              widget.onDetect(codigo);
            }
          },
        ),

        /// Marco del escáner
        Center(
          child: Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.green,
                width: 4,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),

      ],
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}