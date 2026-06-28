import 'package:flutter/material.dart';

class RealtimeProvider extends ChangeNotifier {
  /// Información general
  String nombreLote = "Lote Norte";
  String ultimaActualizacion = "12:35";

  /// Sensores
  double temperatura = 26.5;
  double humedad = 42;
  double humedadGrano = 18;
  double radiacion = 315;
  double viento = 4.2;

  /// Estado del sistema
  String estado = "Sistema estable";

  /// Historial
  final List<double> historial = [
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

  void actualizarDatos({
    double? nuevaTemperatura,
    double? nuevaHumedad,
    double? nuevaHumedadGrano,
    double? nuevaRadiacion,
    double? nuevoViento,
  }) {
    if (nuevaTemperatura != null) temperatura = nuevaTemperatura;
    if (nuevaHumedad != null) humedad = nuevaHumedad;
    if (nuevaHumedadGrano != null) humedadGrano = nuevaHumedadGrano;
    if (nuevaRadiacion != null) radiacion = nuevaRadiacion;
    if (nuevoViento != null) viento = nuevoViento;

    final ahora = TimeOfDay.now();

    ultimaActualizacion =
    "${ahora.hour.toString().padLeft(2, '0')}:${ahora.minute.toString().padLeft(2, '0')}";

    notifyListeners();
  }
}