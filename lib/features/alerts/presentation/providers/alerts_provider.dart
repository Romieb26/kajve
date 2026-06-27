import 'package:flutter/material.dart';

class AlertModel {
  final String titulo;
  final String descripcion;
  final String prioridad;
  bool revisada;

  AlertModel({
    required this.titulo,
    required this.descripcion,
    required this.prioridad,
    this.revisada = false,
  });
}

class AlertsProvider extends ChangeNotifier {
  final List<AlertModel> alerts = [
    AlertModel(
      titulo: "Alta prioridad",
      descripcion:
      "Humedad elevada detectada en el lote A. Revisar inmediatamente.",
      prioridad: "Alta",
    ),
    AlertModel(
      titulo: "Alta prioridad",
      descripcion:
      "Temperatura superior a 35°C durante más de 15 minutos.",
      prioridad: "Alta",
    ),
    AlertModel(
      titulo: "Media prioridad",
      descripcion:
      "Disminución de humedad detectada.",
      prioridad: "Media",
    ),
    AlertModel(
      titulo: "Baja prioridad",
      descripcion:
      "Sensor reconectado correctamente.",
      prioridad: "Baja",
      revisada: true,
    ),
  ];

  void marcarRevisada(int index) {
    alerts[index].revisada = true;
    notifyListeners();
  }
}