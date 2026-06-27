import 'package:flutter/material.dart';

class PredictionProvider extends ChangeNotifier {
  double porcentajeSecado = 76;

  String tiempoRestante = "2 días";
  String fechaEstimada = "18 Julio 2026";
  String calidadEsperada = "91/100";
  String estado = "Óptimo";

  final List<String> recomendaciones = [
    "Mantener temperatura entre 25°C y 28°C.",
    "Reducir humedad ambiental al 40%.",
    "Evitar exposición directa al sol.",
    "Revisar sensores cada 6 horas."
  ];
}