import 'package:flutter/material.dart';

class Lote {
  final String nombre;
  final String fecha;
  final String estado;
  final Color colorEstado;

  Lote({
    required this.nombre,
    required this.fecha,
    required this.estado,
    required this.colorEstado,
  });
}

class LotProvider extends ChangeNotifier {

  // Buscador
  final TextEditingController searchController = TextEditingController();

  // Formulario
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController tipoController = TextEditingController();
  final TextEditingController fechaController = TextEditingController();
  final TextEditingController ubicacionController = TextEditingController();

  bool humedad = false;
  bool temperatura = false;

  final List<Lote> _todos = [
    Lote(
      nombre: "osiles B-Sibaca",
      fecha: "2 may 2026",
      estado: "Excelente",
      colorEstado: Colors.green,
    ),
    Lote(
      nombre: "osiles D-Ocosingo",
      fecha: "10 jun 2026",
      estado: "Favorito",
      colorEstado: Colors.green,
    ),
    Lote(
      nombre: "osilesH-la gloria",
      fecha: "9 ene 2026",
      estado: "Peligro",
      colorEstado: Colors.red,
    ),
  ];

  List<Lote> lotes = [];

  LotProvider() {
    lotes = List.from(_todos);
  }

  void buscar(String texto) {
    if (texto.isEmpty) {
      lotes = List.from(_todos);
    } else {
      lotes = _todos.where((lote) {
        return lote.nombre.toLowerCase().contains(texto.toLowerCase());
      }).toList();
    }

    notifyListeners();
  }

  void cambiarHumedad(bool value) {
    humedad = value;
    notifyListeners();
  }

  void cambiarTemperatura(bool value) {
    temperatura = value;
    notifyListeners();
  }

  void guardarLote() {
    print(nombreController.text);
    print(tipoController.text);
    print(fechaController.text);
    print(ubicacionController.text);
  }

  @override
  void dispose() {
    searchController.dispose();
    nombreController.dispose();
    tipoController.dispose();
    fechaController.dispose();
    ubicacionController.dispose();
    super.dispose();
  }
}