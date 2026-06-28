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
  ///=========================
  /// Buscador
  ///=========================

  final TextEditingController searchController = TextEditingController();

  ///=========================
  /// Formulario
  ///=========================

  final TextEditingController nombreController = TextEditingController();
  final TextEditingController tipoController = TextEditingController();
  final TextEditingController fechaController = TextEditingController();
  final TextEditingController ubicacionController = TextEditingController();

  ///=========================
  /// Sensores
  ///=========================

  bool humedad = false;
  bool temperatura = false;

  ///=========================
  /// Datos de ejemplo
  ///=========================

  final List<Lote> _todos = [
    Lote(
      nombre: "Osiles B - Sibaca",
      fecha: "02/05/2026",
      estado: "Excelente",
      colorEstado: Colors.green,
    ),
    Lote(
      nombre: "Osiles D - Ocosingo",
      fecha: "10/06/2026",
      estado: "En proceso",
      colorEstado: Colors.orange,
    ),
    Lote(
      nombre: "Osiles H - La Gloria",
      fecha: "09/01/2026",
      estado: "Peligro",
      colorEstado: Colors.red,
    ),
  ];

  List<Lote> lotes = [];

  ///=========================
  /// Constructor
  ///=========================

  LotProvider() {
    lotes = List.from(_todos);
  }

  ///=========================
  /// Buscar lote
  ///=========================

  void buscar(String texto) {
    if (texto.isEmpty) {
      lotes = List.from(_todos);
    } else {
      lotes = _todos.where((lote) {
        return lote.nombre.toLowerCase().contains(
          texto.toLowerCase(),
        );
      }).toList();
    }

    notifyListeners();
  }

  ///=========================
  /// Sensores
  ///=========================

  void cambiarHumedad(bool value) {
    humedad = value;
    notifyListeners();
  }

  void cambiarTemperatura(bool value) {
    temperatura = value;
    notifyListeners();
  }

  ///=========================
  /// Registrar lote
  ///=========================

  void registrarLote(BuildContext context) {
    if (nombreController.text.isEmpty ||
        tipoController.text.isEmpty ||
        fechaController.text.isEmpty ||
        ubicacionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Complete todos los campos."),
        ),
      );
      return;
    }

    final nuevoLote = Lote(
      nombre: nombreController.text,
      fecha: fechaController.text,
      estado: "Registrado",
      colorEstado: Colors.blue,
    );

    _todos.add(nuevoLote);

    lotes = List.from(_todos);

    nombreController.clear();
    tipoController.clear();
    fechaController.clear();
    ubicacionController.clear();

    humedad = false;
    temperatura = false;

    notifyListeners();

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Lote registrado correctamente."),
      ),
    );
  }

  ///=========================
  /// Eliminar lote
  ///=========================

  void eliminarLote(int index) {
    _todos.removeAt(index);

    lotes = List.from(_todos);

    notifyListeners();
  }

  ///=========================
  /// Limpiar formulario
  ///=========================

  void limpiarFormulario() {
    nombreController.clear();
    tipoController.clear();
    fechaController.clear();
    ubicacionController.clear();

    humedad = false;
    temperatura = false;

    notifyListeners();
  }

  ///=========================
  /// Dispose
  ///=========================

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