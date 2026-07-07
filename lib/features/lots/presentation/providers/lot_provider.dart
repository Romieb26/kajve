import 'package:flutter/material.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../data/datasources/lot_remote_datasource.dart';
import '../../data/datasources/lots_remote_datasource.dart';
import '../../data/repositories/lot_repository_impl.dart';
import '../../data/repositories/lots_repository_impl.dart';
import '../../domain/create_lote_usecase.dart';
import '../../domain/usecases/get_lots.dart';

class Lote {
  // Id real devuelto por POST /lotes. Null en los lotes de ejemplo,
  // que nunca existieron en el backend.
  final int? id;
  final String nombre;
  final String fecha;
  final String estado;
  final Color colorEstado;

  Lote({
    this.id,
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

  late final GetLotsUseCase _getLotsUseCase = GetLotsUseCase(
    LotRepositoryImpl(
      LotRemoteDataSourceImpl(ApiClient(), SecureStorage()),
    ),
  );

  void seleccionarTipoProceso(String? value) {
    tipoProceso = value;
    notifyListeners();
  }

  ///=========================
  /// Listado de lotes (GET /lotes)
  ///=========================

  List<Lote> _todos = [];
  List<Lote> lotes = [];

  bool cargandoLotes = false;
  String? errorLotes;

  Future<void> cargarLotes() async {
    cargandoLotes = true;
    errorLotes = null;
    notifyListeners();

    try {
      final resultado = await _getLotsUseCase();

      _todos = resultado
          .map(
            (lote) => Lote(
              id: lote.idLote,
              nombre: lote.nombreLote,
              fecha: lote.createdAt != null
                  ? _formatearFecha(lote.createdAt!)
                  : "Sin fecha",
              estado: lote.estado.isNotEmpty ? lote.estado : "Sin estado",
              colorEstado: _colorPorEstado(lote.estado),
            ),
          )
          .toList();

      buscar(searchController.text);
    } on ApiException catch (e) {
      errorLotes = e.statusCode == 401
          ? "Tu sesión expiró. Inicia sesión de nuevo."
          : "No se pudo conectar. Intenta de nuevo";
    } catch (_) {
      errorLotes = "Ocurrió un error al cargar los lotes.";
    } finally {
      cargandoLotes = false;
      notifyListeners();
    }
  }

  String _formatearFecha(DateTime fecha) {
    final dia = fecha.day.toString().padLeft(2, '0');
    final mes = fecha.month.toString().padLeft(2, '0');
    return "$dia/$mes/${fecha.year}";
  }

  Color _colorPorEstado(String estado) {
    final valor = estado.toLowerCase();

    if (valor.contains("riesgo") ||
        valor.contains("peligro") ||
        valor.contains("alerta")) {
      return Colors.red;
    }

    if (valor.contains("proceso") ||
        valor.contains("secando") ||
        valor.contains("activo")) {
      return Colors.orange;
    }

    if (valor.contains("final") ||
        valor.contains("óptimo") ||
        valor.contains("optimo") ||
        valor.contains("excelente") ||
        valor.contains("completado")) {
      return Colors.green;
    }

    return Colors.blueGrey;
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

      // Refresca desde GET /lotes en vez de simular el registro
      // localmente, para que la lista siempre refleje al backend.
      await cargarLotes();

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
