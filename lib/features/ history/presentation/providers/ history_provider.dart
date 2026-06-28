import 'package:flutter/material.dart';

import '../../data/models/history_model.dart';

class HistoryProvider extends ChangeNotifier {

  final TextEditingController searchController =
  TextEditingController();

  final List<HistoryModel> _todos = [

    HistoryModel(
      lote: "Lote Norte",
      fecha: "18 Jul 2026",
      temperatura: 26,
      humedad: 42,
      estado: "Óptimo",
    ),

    HistoryModel(
      lote: "Lote Centro",
      fecha: "17 Jul 2026",
      temperatura: 25,
      humedad: 41,
      estado: "Bueno",
    ),

    HistoryModel(
      lote: "Lote Sur",
      fecha: "16 Jul 2026",
      temperatura: 28,
      humedad: 45,
      estado: "Alerta",
    ),

  ];

  List<HistoryModel> historial = [];

  String filtro = "Todos";

  HistoryProvider() {
    historial = List.from(_todos);
  }

  void buscar(String texto) {

    historial = _todos.where((item) {

      return item.lote
          .toLowerCase()
          .contains(texto.toLowerCase());

    }).toList();

    notifyListeners();
  }

  void cambiarFiltro(String nuevo) {

    filtro = nuevo;

    notifyListeners();

  }

  @override
  void dispose() {

    searchController.dispose();

    super.dispose();

  }
}