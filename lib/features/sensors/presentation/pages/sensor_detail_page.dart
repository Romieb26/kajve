//libs/features/sensors/presentation/pages/sensor_detail_page.dart
import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/storage/secure_storage.dart';
import '../../../realtime/data/datasources/realtime_ws_datasource.dart';
import '../../../realtime/domain/entities/lectura_tiempo_real_entity.dart';
import '../../../realtime/presentation/widgets/variable_config.dart';
import '../../data/models/sensor_model.dart';
import '../widgets/sensor_info_card.dart';

/// Cuántas lecturas recientes se guardan para decidir si una variable
/// está realmente desconectada (ver _estaActiva más abajo).
const int _lecturasParaDetectarDesconexion = 3;

/// Si no llega NINGÚN mensaje nuevo (ni siquiera un ping del WebSocket)
/// en este tiempo, se asume que el ESP32 dejó de mandar datos por
/// completo y se marca todo OFFLINE — el ESP32 manda cada 5s, así que 3
/// ciclos perdidos ya es una desconexión real, no un mensaje tardío.
const Duration _umbralSilencioTotal = Duration(seconds: 15);

/// Detalle de un sensor: además de nombre/tipo/código (SensorInfoCard),
/// se conecta al mismo WebSocket de ws-gateway que usa la pantalla de
/// Tiempo Real (GET /ws/lotes/{id_lote}) para mostrar, variable por
/// variable, si sigue mandando datos ("ON") o dejó de hacerlo
/// ("OFFLINE") — en vez de solo números, que no dicen nada si el sensor
/// se desconectó a media lectura.
class SensorDetailPage extends StatefulWidget {
  final SensorModel sensor;

  const SensorDetailPage({
    super.key,
    required this.sensor,
  });

  @override
  State<SensorDetailPage> createState() => _SensorDetailPageState();
}

class _SensorDetailPageState extends State<SensorDetailPage>
    with WidgetsBindingObserver {
  final RealtimeWsDataSource _wsDataSource = RealtimeWsDataSource();
  final SecureStorage _secureStorage = SecureStorage();

  StreamSubscription<RealtimeWsMessage>? _subscription;
  LecturaTiempoRealEntity? _ultimaLectura;

  // Últimas lecturas (histórico + en vivo), para detectar una variable
  // "pegada" en el mismo valor — ver _estaActiva.
  final List<LecturaTiempoRealEntity> _historialCorto = [];

  bool _conectando = true;
  bool _conectadoWs = false;
  String? _errorLecturas;

  // Cuándo llegó el último mensaje (historial o lectura en vivo) por el
  // WebSocket. Si el ESP32 deja de mandar CUALQUIER dato, el WebSocket
  // con ws-gateway puede seguir "conectado" perfectamente (es una
  // conexión aparte) — sin esto, la pantalla se queda pegada mostrando el
  // último estado conocido para siempre en vez de pasar a OFFLINE. Ver
  // _datosDesactualizados.
  DateTime? _ultimaActualizacion;
  Timer? _relojDesconexion;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _conectar();
    // No espera a que llegue un mensaje nuevo para reevaluar: sin este
    // timer, "¿ya pasó el umbral de silencio?" solo se recalcularía
    // cuando SÍ llega algo — justo lo contrario de lo que hace falta
    // detectar.
    _relojDesconexion = Timer.periodic(const Duration(seconds: 5), (_) {
      if (mounted) setState(() {});
    });
  }

  // Mismo problema que en Tiempo Real: el sistema operativo mata el
  // WebSocket en segundo plano, y sin esto la pantalla se quedaba
  // pegada mostrando "no hay conexión" al volver a abrir la app.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _reconectar();
    }
  }

  Future<void> _reconectar() async {
    await _subscription?.cancel();
    _wsDataSource.disconnect();
    setState(() {
      _conectando = true;
      _conectadoWs = false;
    });
    await _conectar();
  }

  bool get _datosDesactualizados {
    final ultima = _ultimaActualizacion;
    if (ultima == null) return false;
    return DateTime.now().difference(ultima) > _umbralSilencioTotal;
  }

  Future<void> _conectar() async {
    final loteId = widget.sensor.loteId;
    if (loteId == null) {
      setState(() {
        _conectando = false;
        _errorLecturas =
            "Este sensor todavía no está ligado a ningún lote activo.";
      });
      return;
    }

    final token = await _secureStorage.getAccessToken();
    if (!mounted) return;
    if (token == null) {
      setState(() {
        _conectando = false;
        _errorLecturas = "Tu sesión expiró. Inicia sesión de nuevo.";
      });
      return;
    }

    _subscription = _wsDataSource.connect(loteId, token).listen(
      (mensaje) {
        if (!mounted) return;

        setState(() {
          _conectando = false;
          _conectadoWs = true;
          _ultimaActualizacion = DateTime.now();

          if (mensaje.esHistorial) {
            if (mensaje.historial.isNotEmpty) {
              _ultimaLectura = mensaje.historial.last;
            }
            // Se siembra el historial corto con la cola del histórico
            // para no tener que esperar varias lecturas en vivo después
            // de abrir la pantalla para detectar un sensor que ya estaba
            // desconectado.
            final ultimasDelHistorial =
                mensaje.historial.length > _lecturasParaDetectarDesconexion
                    ? mensaje.historial.sublist(
                        mensaje.historial.length -
                            _lecturasParaDetectarDesconexion,
                      )
                    : mensaje.historial;
            _historialCorto
              ..clear()
              ..addAll(ultimasDelHistorial);
          } else if (mensaje.lectura != null) {
            _ultimaLectura = mensaje.lectura;
            _historialCorto.add(mensaje.lectura!);
            if (_historialCorto.length > _lecturasParaDetectarDesconexion) {
              _historialCorto.removeAt(0);
            }
          }
        });
      },
      onError: (_) {
        if (!mounted) return;
        setState(() {
          _conectando = false;
          _conectadoWs = false;
          _errorLecturas = "No se pudo conectar con el servidor de lecturas.";
        });
      },
      onDone: () {
        if (!mounted) return;
        setState(() => _conectadoWs = false);
      },
    );
  }

  /// Sensores que se autodetectan en el firmware (bmp280/ds18b20/bh1750):
  /// su estado_sensores es información real y confiable, así que se usa
  /// directo. fc37 y humedad_suelo son analógicos puros — el ESP32 los
  /// manda siempre en true porque no tiene forma de saber si siguen
  /// conectados — así que para esos dos NO se confía en estado_sensores y
  /// se sigue usando el heurístico de abajo.
  static const _sensoresAutodetectados = {'bmp280', 'ds18b20', 'bh1750'};

  /// Decide si una variable sigue "viva". Primero intenta usar el estado
  /// real que manda el ESP32 (estado_sensores) cuando el sensor físico que
  /// la mide es de los que se autodetectan. Si no hay ese dato (lecturas
  /// de firmware viejo, o sensores analógicos que siempre reportan true),
  /// cae al heurístico anterior: el firmware, cuando un sensor físico se
  /// desconecta pero el ESP32 sigue mandando el resto de los datos, no
  /// manda null para ese campo, manda 0 (confirmado). Un 0 aislado puede
  /// ser una lectura legítima (ej. "Luz" de noche), así que solo se marca
  /// OFFLINE cuando el valor se queda pegado exactamente en 0 durante
  /// varias lecturas seguidas.
  bool _estaActiva(VariableConfig variable) {
    // Fuente de verdad del backend: "conectado" ya se calcula del lado del
    // servidor según si el sensor mandó una lectura reciente (mismo campo
    // que usa la lista y SensorInfoCard arriba en esta misma pantalla). Si
    // el backend dice que el sensor está desconectado, ninguna variable
    // puede aparecer "ON" -- sin este corte, el heurístico de abajo podía
    // decir "activo" justo después de abrir la pantalla, porque el replay
    // del histórico del WebSocket (mensaje.esHistorial) marca
    // _ultimaActualizacion = DateTime.now() aunque esos datos sean viejos,
    // dejando _datosDesactualizados en false por los primeros 15s aunque
    // el sensor físico llevara horas apagado. Eso era justo la
    // contradicción reportada: la lista decía "Desconectado" y el detalle
    // decía "ON".
    if (!widget.sensor.conectado) return false;
    if (!_conectadoWs || _ultimaLectura == null) return false;
    if (_datosDesactualizados) return false;

    if (_sensoresAutodetectados.contains(variable.sensorFisico)) {
      final estadoReal =
          _ultimaLectura!.estadoSensores?.porClave(variable.sensorFisico);
      if (estadoReal != null) return estadoReal;
    }

    final valorActual = variable.valor(_ultimaLectura!);
    if (valorActual == null) return false;

    // Los booleanos (Lluvia detectada) no aplican la regla de "pegado en
    // 0": no llover es un estado normal, no una falla del sensor.
    if (variable.esBooleana) return true;

    if (valorActual != 0 ||
        _historialCorto.length < _lecturasParaDetectarDesconexion) {
      return true;
    }

    final ultimasN = _historialCorto.sublist(
      _historialCorto.length - _lecturasParaDetectarDesconexion,
    );
    final siemprePegadoEnCero =
        ultimasN.every((l) => variable.valor(l) == 0);
    return !siemprePegadoEnCero;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _relojDesconexion?.cancel();
    _subscription?.cancel();
    _wsDataSource.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalle del Sensor"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SensorInfoCard(sensor: widget.sensor),

            const SizedBox(height: 25),

            const Text(
              "Estado de los sensores",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            if (!_conectando && _datosDesactualizados) ...[
              const SizedBox(height: 4),
              const Text(
                "Sin datos nuevos hace rato — el dispositivo podría estar "
                "apagado o sin señal.",
                style: TextStyle(color: Colors.orange, fontSize: 12),
              ),
            ],

            const SizedBox(height: 12),

            if (_conectando)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 30),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_ultimaLectura == null && _errorLecturas != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    _errorLecturas!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
              )
            else ...[
              for (final variable in variablesEsp32)
                _EstadoVariable(
                  icono: variable.icono,
                  titulo: variable.titulo,
                  activo: _estaActiva(variable),
                ),
              if (_errorLecturas != null) ...[
                const SizedBox(height: 8),
                Text(
                  _errorLecturas!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.orange, fontSize: 12),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

class _EstadoVariable extends StatelessWidget {
  final IconData icono;
  final String titulo;
  final bool activo;

  const _EstadoVariable({
    required this.icono,
    required this.titulo,
    required this.activo,
  });

  @override
  Widget build(BuildContext context) {
    final color = activo ? Colors.green : Colors.red;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(icono, color: color),
        title: Text(titulo),
        trailing: Chip(
          label: Text(activo ? "ON" : "OFFLINE"),
          backgroundColor: color.withValues(alpha: 0.15),
          labelStyle: TextStyle(color: color, fontWeight: FontWeight.bold),
          side: BorderSide.none,
        ),
      ),
    );
  }
}
