//libs/features/sensors/presentation/providers/sensor_provider.dart
import 'package:flutter/material.dart';

import '../../../../core/network/api_client.dart';
import '../../data/datasources/sensor_status_remote_datasource.dart';
import '../../data/models/sensor_model.dart';

class SensorProvider extends ChangeNotifier {

  final searchController = TextEditingController();

  final nombreController = TextEditingController();

  final tipoController = TextEditingController();

  final codigoController = TextEditingController();

  final loteController = TextEditingController();

  bool conectado = true;

  bool isLoading = false;
  String? errorMessage;

  final SensorStatusRemoteDataSource _dataSource =
      SensorStatusRemoteDataSource();

  /// Sensores tal como los devolvió el backend la última vez (sin
  /// filtrar). `sensores` es lo que la UI realmente pinta, ya filtrado
  /// por el buscador.
  List<SensorModel> _todos = [];

  List<SensorModel> sensores = [];

  SensorProvider() {
    cargarSensores();
  }

  /// Trae el estado real de los sensores desde
  /// `GET /sensores/estado` de ws-gateway: "conectado" ya no es un valor
  /// fijo, se calcula allá según si el sensor mandó una lectura reciente.
  Future<void> cargarSensores() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      _todos = await _dataSource.getEstadoSensores();
      sensores = _filtrarPorTexto(searchController.text);
    } on ApiException catch (e) {
      errorMessage = e.statusCode == 401
          ? "Tu sesión expiró. Inicia sesión de nuevo."
          : "No se pudo conectar con el servidor de sensores.";
    } catch (_) {
      errorMessage = "Ocurrió un error al cargar los sensores.";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void buscar(String texto) {
    sensores = _filtrarPorTexto(texto);
    notifyListeners();
  }

  List<SensorModel> _filtrarPorTexto(String texto) {
    if (texto.isEmpty) return List.from(_todos);

    final buscado = texto.toLowerCase();
    return _todos.where((sensor) {
      return sensor.nombre.toLowerCase().contains(buscado) ||
          sensor.lote.toLowerCase().contains(buscado);
    }).toList();
  }

  void cambiarEstado(bool value) {
    conectado = value;
    notifyListeners();
  }

  // Registro manual de un sensor: todavía no existe un endpoint de alta
  // de sensores, así que esto solo lo agrega a la lista en memoria (se
  // pierde al recargar desde el backend con cargarSensores()).
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
