import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/create_lote_usecase.dart';
import '../../domain/usecases/get_lots.dart';

part 'lot_provider.g.dart';

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

class LotState {
  final String? tipoProceso;
  final bool cargando;
  final String? codigoQrGenerado;

  final List<Lote> todos;
  final List<Lote> lotes;
  final bool cargandoLotes;
  final String? errorLotes;

  const LotState({
    this.tipoProceso,
    this.cargando = false,
    this.codigoQrGenerado,
    this.todos = const [],
    this.lotes = const [],
    this.cargandoLotes = false,
    this.errorLotes,
  });

  LotState copyWith({
    String? tipoProceso,
    bool clearTipoProceso = false,
    bool? cargando,
    String? codigoQrGenerado,
    bool clearCodigoQr = false,
    List<Lote>? todos,
    List<Lote>? lotes,
    bool? cargandoLotes,
    String? errorLotes,
    bool clearErrorLotes = false,
  }) {
    return LotState(
      tipoProceso: clearTipoProceso ? null : (tipoProceso ?? this.tipoProceso),
      cargando: cargando ?? this.cargando,
      codigoQrGenerado:
          clearCodigoQr ? null : (codigoQrGenerado ?? this.codigoQrGenerado),
      todos: todos ?? this.todos,
      lotes: lotes ?? this.lotes,
      cargandoLotes: cargandoLotes ?? this.cargandoLotes,
      errorLotes: clearErrorLotes ? null : (errorLotes ?? this.errorLotes),
    );
  }
}

@riverpod
class LotController extends _$LotController {
  ///=========================
  /// Buscador
  ///=========================
  final searchController = TextEditingController();

  ///=========================
  /// Formulario
  ///=========================
  final nombreController = TextEditingController();
  final variedadController = TextEditingController();
  final pesoController = TextEditingController();
  final ubicacionController = TextEditingController();
  final sensorIdController = TextEditingController();

  @override
  LotState build() {
    ref.onDispose(() {
      searchController.dispose();
      nombreController.dispose();
      variedadController.dispose();
      pesoController.dispose();
      ubicacionController.dispose();
      sensorIdController.dispose();
    });
    return const LotState();
  }

  void seleccionarTipoProceso(String? value) {
    state = value == null
        ? state.copyWith(clearTipoProceso: true)
        : state.copyWith(tipoProceso: value);
  }

  ///=========================
  /// Listado de lotes (GET /lotes)
  ///=========================

  Future<void> cargarLotes() async {
    state = state.copyWith(cargandoLotes: true, clearErrorLotes: true);

    try {
      final resultado = await getIt<GetLotsUseCase>()();

      final todos = resultado
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

      state = state.copyWith(todos: todos);
      buscar(searchController.text);
    } on ApiException catch (e) {
      state = state.copyWith(
        errorLotes: e.statusCode == 401
            ? "Tu sesión expiró. Inicia sesión de nuevo."
            : "No se pudo conectar. Intenta de nuevo",
      );
    } catch (_) {
      state = state.copyWith(
        errorLotes: "Ocurrió un error al cargar los lotes.",
      );
    } finally {
      state = state.copyWith(cargandoLotes: false);
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
    final lotes = texto.isEmpty
        ? List<Lote>.from(state.todos)
        : state.todos
            .where((lote) => lote.nombre.toLowerCase().contains(texto.toLowerCase()))
            .toList();

    state = state.copyWith(lotes: lotes);
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

    final tipoProceso = state.tipoProceso;
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

    state = state.copyWith(cargando: true);

    try {
      final lote = await getIt<CreateLoteUseCase>()(
        nombreLote: nombreController.text.trim(),
        variedad: variedadController.text.trim(),
        tipoProceso: tipoProceso,
        pesoKg: peso,
        ubicacion: ubicacionController.text.trim(),
        idSensor: idSensor,
      );

      state = state.copyWith(codigoQrGenerado: lote.codigoQr);

      // Refresca desde GET /lotes en vez de simular el registro
      // localmente, para que la lista siempre refleje al backend.
      await cargarLotes();

      nombreController.clear();
      variedadController.clear();
      pesoController.clear();
      ubicacionController.clear();
      sensorIdController.clear();
      state = state.copyWith(clearTipoProceso: true);

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
      state = state.copyWith(cargando: false);
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
    state = state.copyWith(clearCodigoQr: true);
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

    state = state.copyWith(clearTipoProceso: true, clearCodigoQr: true);
  }
}
