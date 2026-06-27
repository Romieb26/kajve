import 'package:flutter/material.dart';

class QrProvider extends ChangeNotifier {
  bool flash = false;

  void toggleFlash() {
    flash = !flash;
    notifyListeners();
  }

  void scanQr() {
    // Aquí irá la lógica del escaneo
  }
}