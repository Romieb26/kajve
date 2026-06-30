import 'package:flutter/material.dart';

import '../../data/models/sensor_model.dart';

class SensorProvider extends ChangeNotifier {

  final searchController = TextEditingController();

  final nombreController = TextEditingController();

  final tipoController = TextEditingController();

  final codigoController = TextEditingController();

  final loteController = TextEditingController();

  bool conectado = true;

  final List<SensorModel> _todos = [

    SensorModel(
      nombre: "Sensor 01",
      tipo: "Temperatura",
      codigo: "TMP001",
      lote: "Lote Norte",
      conectado: true,
    ),

    SensorModel(
      nombre: "Sensor 02",
      tipo: "Humedad",
      codigo: "HUM002",
      lote: "Lote Sur",
      conectado: false,
    ),

    SensorModel(
      nombre: "Sensor 03",
      tipo: "Temperatura",
      codigo: "TMP003",
      lote: "Lote Centro",
      conectado: true,
    ),
  ];

  List<SensorModel> sensores = [];

  SensorProvider() {
    sensores = List.from(_todos);
  }

  void buscar(String texto) {

    if (texto.isEmpty) {
      sensores = List.from(_todos);
    } else {
      sensores = _todos.where((sensor) {
        return sensor.nombre
            .toLowerCase()
            .contains(texto.toLowerCase());
      }).toList();
    }

    notifyListeners();
  }

  void cambiarEstado(bool value) {
    conectado = value;
    notifyListeners();
  }

  void guardarSensor() {

    _todos.add(

      SensorModel(
        nombre: nombreController.text,
        tipo: tipoController.text,
        codigo: codigoController.text,
        lote: loteController.text,
        conectado: conectado,
      ),

    );

    sensores = List.from(_todos);

    limpiar();

    notifyListeners();
  }

  void limpiar() {

    nombreController.clear();

    tipoController.clear();

    codigoController.clear();

    loteController.clear();

    conectado = true;
  }

  @override
  void dispose() {

    searchController.dispose();

    nombreController.dispose();

    tipoController.dispose();

    codigoController.dispose();

    loteController.dispose();

    super.dispose();
  }
}