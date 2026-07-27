//libs/features/sensors/presentation/providers/sensor_provider.dart
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/network/api_client.dart';
import '../../data/models/sensor_model.dart';
import '../../domain/usecases/get_estado_sensores_usecase.dart';

part 'sensor_provider.g.dart';

class SensorState {
  final bool conectado;
  final bool isLoading;
  final String? errorMessage;

  /// Sensores tal como los devolvió el backend la última vez (sin
  /// filtrar). `sensores` es lo que la UI realmente pinta, ya filtrado
  /// por el buscador.
  final List<SensorModel> todos;
  final List<SensorModel> sensores;

  const SensorState({
    this.conectado = true,
    this.isLoading = false,
    this.errorMessage,
    this.todos = const [],
    this.sensores = const [],
  });

  SensorState copyWith({
    bool? conectado,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
    List<SensorModel>? todos,
    List<SensorModel>? sensores,
  }) {
    return SensorState(
      conectado: conectado ?? this.conectado,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      todos: todos ?? this.todos,
      sensores: sensores ?? this.sensores,
    );
  }
}

@riverpod
class SensorController extends _$SensorController {
  final searchController = TextEditingController();
  final nombreController = TextEditingController();
  final tipoController = TextEditingController();
  final codigoController = TextEditingController();
  final loteController = TextEditingController();

  @override
  SensorState build() {
    ref.onDispose(() {
      searchController.dispose();
      nombreController.dispose();
      tipoController.dispose();
      codigoController.dispose();
      loteController.dispose();
    });

    // Igual que el ChangeNotifier original: se auto-carga apenas se crea.
    Future.microtask(cargarSensores);
    return const SensorState();
  }

  /// Trae el estado real de los sensores desde
  /// `GET /sensores/estado` de ws-gateway: "conectado" ya no es un valor
  /// fijo, se calcula allá según si el sensor mandó una lectura reciente.
  Future<void> cargarSensores() async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final todos = await getIt<GetEstadoSensoresUseCase>()();
      state = state.copyWith(
        todos: todos,
        sensores: _filtrarPorTexto(todos, searchController.text),
      );
    } on ApiException catch (e) {
      state = state.copyWith(
        errorMessage: e.statusCode == 401
            ? "Tu sesión expiró. Inicia sesión de nuevo."
            : "No se pudo conectar con el servidor de sensores.",
      );
    } catch (_) {
      state = state.copyWith(
        errorMessage: "Ocurrió un error al cargar los sensores.",
      );
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  void buscar(String texto) {
    state = state.copyWith(sensores: _filtrarPorTexto(state.todos, texto));
  }

  List<SensorModel> _filtrarPorTexto(List<SensorModel> todos, String texto) {
    if (texto.isEmpty) return List.from(todos);

    final buscado = texto.toLowerCase();
    return todos.where((sensor) {
      return sensor.nombre.toLowerCase().contains(buscado) ||
          sensor.lote.toLowerCase().contains(buscado);
    }).toList();
  }

  void cambiarEstado(bool value) {
    state = state.copyWith(conectado: value);
  }

  // Registro manual de un sensor: todavía no existe un endpoint de alta
  // de sensores, así que esto solo lo agrega a la lista en memoria (se
  // pierde al recargar desde el backend con cargarSensores()).
  void guardarSensor() {
    final nuevo = SensorModel(
      nombre: nombreController.text,
      tipo: tipoController.text,
      codigo: codigoController.text,
      lote: loteController.text,
      conectado: state.conectado,
    );

    final todos = [...state.todos, nuevo];
    state = state.copyWith(todos: todos, sensores: List.from(todos));

    limpiar();
  }

  void limpiar() {
    nombreController.clear();
    tipoController.clear();
    codigoController.clear();
    loteController.clear();

    state = state.copyWith(conectado: true);
  }
}
