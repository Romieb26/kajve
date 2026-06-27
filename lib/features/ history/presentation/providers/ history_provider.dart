import 'package:flutter/material.dart';

class HistoryModel {
  final String lote;
  final String fecha;
  final String temperatura;
  final String humedad;
  final String estado;

  HistoryModel({
    required this.lote,
    required this.fecha,
    required this.temperatura,
    required this.humedad,
    required this.estado,
  });
}

class HistoryProvider extends ChangeNotifier {
  final TextEditingController searchController = TextEditingController();

  List<HistoryModel> historial = [
    HistoryModel(
      lote: "Lote A",
      fecha: "10/07/2026",
      temperatura: "26°C",
      humedad: "42%",
      estado: "Finalizado",
    ),
    HistoryModel(
      lote: "Lote B",
      fecha: "11/07/2026",
      temperatura: "28°C",
      humedad: "39%",
      estado: "En proceso",
    ),
    HistoryModel(
      lote: "Lote C",
      fecha: "12/07/2026",
      temperatura: "25°C",
      humedad: "45%",
      estado: "Finalizado",
    ),
    HistoryModel(
      lote: "Lote D",
      fecha: "13/07/2026",
      temperatura: "27°C",
      humedad: "41%",
      estado: "En proceso",
    ),
  ];

  List<HistoryModel> get resultados {
    if (searchController.text.isEmpty) return historial;

    return historial.where((element) {
      return element.lote.toLowerCase().contains(
        searchController.text.toLowerCase(),
      );
    }).toList();
  }

  void buscar(String value) {
    notifyListeners();
  }
}