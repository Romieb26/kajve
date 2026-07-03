import 'package:flutter/material.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../data/datasources/lots_remote_datasource.dart';
import '../../data/repositories/lots_repository_impl.dart';
import '../../domain/create_lote_usecase.dart';

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

/// Valores exactos que acepta tipo_proceso en el backend.
const List<String> tiposProcesoValidos = ['lavado', 'honey', 'natural'];

class LotProvider extends ChangeNotifier {
  ///=========================
  /// Buscador
  ///=========================

  final TextEditingController searchController = TextEditingController();

  ///=========================
  /// Formulario
  ///=========================

  final TextEditingController nombreController = TextEditingController();
  final TextEditingController variedadController = TextEditingController();
  final TextEditingController pesoController = TextEditingController();
  final TextEditingController ubicacionController = TextEditingController();
  final TextEditingController sensorIdController = TextEditingController();

  String? tipoProceso;

  bool cargando = false;
  String? codigoQrGenerado;

  late final CreateLoteUseCase _createLoteUseCase = CreateLoteUseCase(
    LotsRepositoryImpl(
      LotsRemoteDataSourceImpl(ApiClient(), SecureStorage()),
    ),
  );

  void seleccionarTipoProceso(String? value) {
    tipoProceso = value;
    notifyListeners();
  }

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
  /// Registrar lote (POST /lotes)
  ///=========================

  Future<void> registrarLote(BuildContext context) async {
    if (nombreController.text.trim().isEmpty ||
        variedadController.text.trim().isEmpty ||
        pesoController.text.trim().isEmpty ||
        ubicacionController.text.trim().isEmpty) {
      _mostrarSnackBar(context, "Complete todos los campos.", Colors.orange);
      return;
    }

    if (tipoProceso == null || !tiposProcesoValidos.contains(tipoProceso)) {
      _mostrarSnackBar(
        context,
        "Selecciona el tipo de proceso.",
        Colors.orange,
      );
      return;
    }

    final peso = double.tryParse(
      pesoController.text.trim().replaceAll(',', '.'),
    );

    if (peso == null || peso <= 0) {
      _mostrarSnackBar(
        context,
        "Ingresa un peso válido, mayor a 0.",
        Colors.orange,
      );
      return;
    }

    int? idSensor;

    if (sensorIdController.text.trim().isNotEmpty) {
      idSensor = int.tryParse(sensorIdController.text.trim());

      if (idSensor == null) {
        _mostrarSnackBar(
          context,
          "El ID de sensor debe ser un número.",
          Colors.orange,
        );
        return;
      }
    }

    cargando = true;
    notifyListeners();

    try {
      final lote = await _createLoteUseCase(
        nombreLote: nombreController.text.trim(),
        variedad: variedadController.text.trim(),
        tipoProceso: tipoProceso!,
        pesoKg: peso,
        ubicacion: ubicacionController.text.trim(),
        idSensor: idSensor,
      );

      codigoQrGenerado = lote.codigoQr;

      // Refleja el lote nuevo en la lista local mientras no exista
      // una pantalla de listado conectada a GET /lotes.
      _todos.add(
        Lote(
          nombre: nombreController.text.trim(),
          fecha: _fechaHoy(),
          estado: "Registrado",
          colorEstado: Colors.blue,
        ),
      );
      lotes = List.from(_todos);

      nombreController.clear();
      variedadController.clear();
      pesoController.clear();
      ubicacionController.clear();
      sensorIdController.clear();
      tipoProceso = null;

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Lote registrado correctamente."),
            backgroundColor: Colors.green,
          ),
        );
      }
    } on ApiException catch (e) {
      if (context.mounted) {
        _mostrarSnackBar(context, e.message, Colors.red);
      }
    } finally {
      cargando = false;
      notifyListeners();
    }
  }

  String _fechaHoy() {
    final ahora = DateTime.now();
    final dia = ahora.day.toString().padLeft(2, '0');
    final mes = ahora.month.toString().padLeft(2, '0');
    return "$dia/$mes/${ahora.year}";
  }

  void _mostrarSnackBar(BuildContext context, String mensaje, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje), backgroundColor: color),
    );
  }

  ///=========================
  /// Cerrar QR (botón "Volver a Lotes")
  ///=========================

  void ocultarQr() {
    codigoQrGenerado = null;
    notifyListeners();
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
    variedadController.clear();
    pesoController.clear();
    ubicacionController.clear();
    sensorIdController.clear();

    tipoProceso = null;
    codigoQrGenerado = null;

    notifyListeners();
  }

  ///=========================
  /// Dispose
  ///=========================

  @override
  void dispose() {
    searchController.dispose();

    nombreController.dispose();
    variedadController.dispose();
    pesoController.dispose();
    ubicacionController.dispose();
    sensorIdController.dispose();

    super.dispose();
  }
}
