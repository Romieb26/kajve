//lib/features/realtime/presentation/widgets/variable_config.dart
import 'package:flutter/material.dart';

import '../../domain/entities/lectura_tiempo_real_entity.dart';

/// Definición de cada variable del ESP32 que se muestra en "Tiempo Real":
/// el mismo listado alimenta tanto las tarjetas rápidas (SensorGrid) como
/// las gráficas (ChartCard), para no tener dos listas que se puedan
/// desincronizar.
///
/// Alineado con la migración de BD / ingesta-iot / ws-gateway: se quitó
/// "Humedad ambiente" (el BMP280 no la mide; la columna ya no existe) y la
/// vieja "Lluvia" (normalizada 0-1) se separó en dos variables: la lectura
/// analógica cruda del FC-37 y si detectó lluvia o no.
class VariableConfig {
  final String titulo;
  final String unidad;
  final IconData icono;
  final Color color;
  final double? Function(LecturaTiempoRealEntity) valor;

  /// Formatea el valor numérico ya extraído para mostrarlo en las tarjetas
  /// (SensorGrid) y debajo de la gráfica (ChartCard). Por defecto es el
  /// número con su unidad; "Lluvia detectada" la sobrescribe para mostrar
  /// "Sí"/"No" en vez de "1.0"/"0.0".
  final String Function(double valor)? formatoValor;

  /// true solo para "Lluvia detectada": es un booleano (0/1), y un 0
  /// legítimo ahí significa "no está lloviendo" (un estado normal y común),
  /// no una falla del sensor. El detector de sensor desconectado en
  /// SensorDetailPage (que marca OFFLINE cuando un valor se queda pegado
  /// en 0 por varias lecturas seguidas) usa esta bandera para no aplicar
  /// esa regla aquí — si no, se marcaría "offline" cada vez que
  /// simplemente no está lloviendo.
  final bool esBooleana;

  /// Clave del sensor físico que mide esta variable, tal como llega en
  /// estado_sensores ('bmp280','ds18b20','bh1750','fc37','humedad_suelo').
  /// La usa SensorDetailPage para saber si puede confiar en el estado
  /// real que manda el ESP32 (bmp280/ds18b20/bh1750 se autodetectan) o si
  /// debe seguir usando el heurístico de "valor pegado en 0" (fc37 y
  /// humedad_suelo son analógicos puros: el firmware siempre los manda en
  /// true, así que ese campo no es confiable para ellos).
  final String sensorFisico;

  const VariableConfig({
    required this.titulo,
    required this.unidad,
    required this.icono,
    required this.color,
    required this.valor,
    required this.sensorFisico,
    this.formatoValor,
    this.esBooleana = false,
  });

  String formatear(double valor) {
    if (formatoValor != null) return formatoValor!(valor);
    final unidadSufijo = unidad.isEmpty ? '' : ' $unidad';
    return "${valor.toStringAsFixed(1)}$unidadSufijo";
  }
}

double? _temperatura(LecturaTiempoRealEntity l) => l.temperatura;
double? _temperaturaGrano(LecturaTiempoRealEntity l) => l.temperaturaGrano;
double? _humedadGrano(LecturaTiempoRealEntity l) => l.humedadGrano;
double? _presionHpa(LecturaTiempoRealEntity l) => l.presionHpa;
double? _altitudM(LecturaTiempoRealEntity l) => l.altitudM;
double? _luz(LecturaTiempoRealEntity l) => l.luz;
double? _lluviaAnalog(LecturaTiempoRealEntity l) => l.lluviaAnalog;

// La gráfica y el grid solo trabajan con double, así que el booleano se
// representa como 1.0 (sí)/0.0 (no) — de paso permite ver en la gráfica
// los momentos en los que llovió.
double? _lluviaDetectada(LecturaTiempoRealEntity l) {
  final detectada = l.lluviaDetectada;
  if (detectada == null) return null;
  return detectada ? 1.0 : 0.0;
}

// Debe ser una función top-level (no una lambda inline) para poder
// referenciarla dentro de la lista const de abajo — un closure anónimo no
// es una expresión constante en Dart.
String _formatoSiNo(double v) => v >= 1 ? "Sí" : "No";

const List<VariableConfig> variablesEsp32 = [
  VariableConfig(
    titulo: "Temperatura",
    unidad: "°C",
    icono: Icons.thermostat,
    color: Colors.red,
    valor: _temperatura,
    sensorFisico: "bmp280",
  ),
  VariableConfig(
    titulo: "Temp. del grano",
    unidad: "°C",
    icono: Icons.grain,
    color: Colors.brown,
    valor: _temperaturaGrano,
    sensorFisico: "ds18b20",
  ),
  VariableConfig(
    titulo: "Humedad del grano",
    unidad: "",
    icono: Icons.grain,
    color: Colors.teal,
    valor: _humedadGrano,
    sensorFisico: "humedad_suelo",
  ),
  VariableConfig(
    titulo: "Presión",
    unidad: "hPa",
    icono: Icons.speed,
    color: Colors.deepPurple,
    valor: _presionHpa,
    sensorFisico: "bmp280",
  ),
  VariableConfig(
    titulo: "Altitud",
    unidad: "m",
    icono: Icons.terrain,
    color: Colors.indigo,
    valor: _altitudM,
    sensorFisico: "bmp280",
  ),
  VariableConfig(
    titulo: "Luz",
    unidad: "lux",
    icono: Icons.wb_sunny,
    color: Colors.amber,
    valor: _luz,
    sensorFisico: "bh1750",
  ),
  VariableConfig(
    titulo: "Lluvia (lectura analógica)",
    unidad: "",
    icono: Icons.opacity,
    color: Colors.lightBlue,
    valor: _lluviaAnalog,
    sensorFisico: "fc37",
  ),
  VariableConfig(
    titulo: "Lluvia detectada",
    unidad: "",
    icono: Icons.umbrella,
    color: Colors.blueAccent,
    valor: _lluviaDetectada,
    formatoValor: _formatoSiNo,
    esBooleana: true,
    sensorFisico: "fc37",
  ),
];
