import 'package:flutter/material.dart';

class MonitoringProvider extends ChangeNotifier {
  ///=========================
  /// Información del lote
  ///=========================

  String nombreLote = "Lote Norte";
  String etapa = "Secado";
  String calidad = "87.5";
  String diasSecado = "8 días";
  String rendimiento = "92 %";

  ///=========================
  /// Sensores
  ///=========================

  double humedad = 42.5;
  double temperatura = 28.3;
  double radiacion = 580.0;
  double viento = 11.2;

  ///=========================
  /// Estado del secado
  ///=========================

  String estadoSecado = "Óptimo";

  Color get colorEstado {
    switch (estadoSecado) {
      case "Óptimo":
        return Colors.green;

      case "En proceso":
        return Colors.orange;

      case "Riesgo":
        return Colors.red;

      default:
        return Colors.grey;
    }
  }

  ///=========================
  /// Recomendaciones
  ///=========================

  List<String> recomendaciones = [
    "Mantener ventilación natural.",
    "No cubrir el café durante el día.",
    "Continuar monitoreando humedad cada hora.",
  ];

  ///=========================
  /// Actualizar sensores
  ///=========================

  void actualizarSensores({
    required double nuevaTemperatura,
    required double nuevaHumedad,
    required double nuevaRadiacion,
    required double nuevoViento,
  }) {
    temperatura = nuevaTemperatura;
    humedad = nuevaHumedad;
    radiacion = nuevaRadiacion;
    viento = nuevoViento;

    notifyListeners();
  }

  ///=========================
  /// Cambiar estado
  ///=========================

  void cambiarEstado(String estado) {
    estadoSecado = estado;
    notifyListeners();
  }

  ///=========================
  /// Agregar recomendación
  ///=========================

  void agregarRecomendacion(String texto) {
    recomendaciones.add(texto);
    notifyListeners();
  }
}