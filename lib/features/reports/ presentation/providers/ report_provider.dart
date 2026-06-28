import 'package:flutter/material.dart';

import '../../data/models/report_model.dart';

class ReportProvider extends ChangeNotifier {
  /// Loading
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  /// Controlador del lote
  final TextEditingController loteController = TextEditingController();

  /// Tipos de reporte
  final List<String> tipos = [
    "Producción",
    "Temperatura",
    "Humedad",
    "Predicción",
  ];

  /// Tipo seleccionado
  String? tipoReporte;

  /// Fecha seleccionada
  DateTime? fechaSeleccionada;

  /// Historial
  final List<ReportModel> reportes = [];

  /// Seleccionar tipo
  void seleccionarTipo(String? tipo) {
    tipoReporte = tipo;
    notifyListeners();
  }

  /// Seleccionar fecha
  Future<void> seleccionarFecha(BuildContext context) async {
    final DateTime? fecha = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2035),
    );

    if (fecha != null) {
      fechaSeleccionada = fecha;
      notifyListeners();
    }
  }

  /// Generar reporte
  void generarReporte() {
    if (loteController.text.isEmpty) return;
    if (tipoReporte == null) return;
    if (fechaSeleccionada == null) return;

    reportes.add(
      ReportModel(
        nombre: loteController.text,
        tipo: tipoReporte!,
        fecha:
        "${fechaSeleccionada!.day}/${fechaSeleccionada!.month}/${fechaSeleccionada!.year}",
      ),
    );

    notifyListeners();
  }

  /// Eliminar reporte
  void eliminarReporte(int index) {
    reportes.removeAt(index);
    notifyListeners();
  }

  @override
  void dispose() {
    loteController.dispose();
    super.dispose();
  }
}