import 'package:flutter/material.dart';
import '../../data/models/alert_model.dart';

class AlertsProvider extends ChangeNotifier {

  final List<AlertModel> _alertas = [
    AlertModel(
      titulo: "Temperatura alta",
      descripcion: "El lote Norte superó los 30°C",
      fecha: "18 Jul 2026",
      nivel: "alta",
    ),
    AlertModel(
      titulo: "Humedad baja",
      descripcion: "Posible secado acelerado",
      fecha: "17 Jul 2026",
      nivel: "media",
    ),
    AlertModel(
      titulo: "Sensor desconectado",
      descripcion: "No hay datos del sensor 2",
      fecha: "16 Jul 2026",
      nivel: "alta",
    ),
  ];

  List<AlertModel> alertas = [];

  String filtro = "Todas";

  AlertsProvider() {
    alertas = List.from(_alertas);
  }

  void filtrar(String nivel) {
    filtro = nivel;

    if (nivel == "Todas") {
      alertas = List.from(_alertas);
    } else {
      alertas = _alertas.where((a) => a.nivel == nivel).toList();
    }

    notifyListeners();
  }
}