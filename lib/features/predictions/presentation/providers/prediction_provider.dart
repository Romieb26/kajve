import 'package:flutter/material.dart';

class PredictionProvider extends ChangeNotifier {

  /// Lote seleccionado
  String loteSeleccionado = "Lote Norte";

  /// Predicción
  double porcentajeSecado = 76;

  String tiempoRestante = "2 días";
  String fechaEstimada = "18 Julio 2026";
  String calidadEsperada = "91/100";
  String estado = "Óptimo";

  /// Confianza del modelo IA
  int confianza = 96;

  /// Recomendaciones
  List<String> recomendaciones = [
    "Mantener temperatura entre 25°C y 28°C.",
    "Reducir humedad ambiental al 40%.",
    "Evitar exposición directa al sol.",
    "Revisar sensores cada 6 horas.",
  ];

  /// Historial de predicciones
  final List<Map<String, dynamic>> historial = [
    {
      "fecha": "15 Jul",
      "avance": 62,
    },
    {
      "fecha": "16 Jul",
      "avance": 68,
    },
    {
      "fecha": "17 Jul",
      "avance": 72,
    },
    {
      "fecha": "18 Jul",
      "avance": 76,
    },
  ];

  void actualizarPrediccion({
    required double porcentaje,
    required String tiempo,
    required String fecha,
    required String calidad,
    required String nuevoEstado,
  }) {
    porcentajeSecado = porcentaje;
    tiempoRestante = tiempo;
    fechaEstimada = fecha;
    calidadEsperada = calidad;
    estado = nuevoEstado;

    notifyListeners();
  }
}