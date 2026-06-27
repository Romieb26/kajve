import 'package:flutter/material.dart';

class RealtimeProvider extends ChangeNotifier {

  double temperatura = 26.5;
  double humedad = 42;
  double humedadGrano = 18;

  List<double> historial = [
    22,
    23,
    25,
    24,
    26,
    27,
    28,
    27,
    26,
  ];

  void actualizarDatos() {
    notifyListeners();
  }
}