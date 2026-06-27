import 'package:flutter/material.dart';

class DashboardProvider extends ChangeNotifier {
  String nombreUsuario = "Juan Pérez";

  int lotesActivos = 12;
  int alertas = 3;
  int predicciones = 28;

  final List<Map<String, dynamic>> ultimasPredicciones = [
    {
      "lote": "Lote A",
      "estado": "Secado óptimo",
      "fecha": "15/08/2026"
    },
    {
      "lote": "Lote B",
      "estado": "Riesgo de humedad",
      "fecha": "14/08/2026"
    },
    {
      "lote": "Lote C",
      "estado": "Temperatura elevada",
      "fecha": "13/08/2026"
    },
  ];
}