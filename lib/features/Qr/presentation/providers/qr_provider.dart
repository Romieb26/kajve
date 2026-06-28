import 'package:flutter/material.dart';

class QrProvider extends ChangeNotifier {
  ///=========================
  /// Flash
  ///=========================

  bool flash = false;

  void toggleFlash() {
    flash = !flash;
    notifyListeners();
  }

  ///=========================
  /// Resultado del QR
  ///=========================

  bool codigoEscaneado = false;

  String lote = "";
  String productor = "";
  String estado = "";
  String fecha = "";

  ///=========================
  /// Simulación del escaneo
  ///=========================

  void scanQr() {
    codigoEscaneado = true;

    lote = "Lote Norte";
    productor = "Finca Sibaca";
    estado = "Secado";
    fecha = "18/06/2026";

    notifyListeners();
  }

  ///=========================
  /// Limpiar información
  ///=========================

  void limpiar() {
    codigoEscaneado = false;

    lote = "";
    productor = "";
    estado = "";
    fecha = "";

    notifyListeners();
  }
}