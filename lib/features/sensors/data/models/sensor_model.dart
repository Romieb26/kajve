//libs/features/sensors/data/models/sensor_model.dart
import 'package:flutter/material.dart';

class SensorModel {
  final int? sensorId;
  final String nombre;
  final String tipo;
  final String codigo;
  final String lote;
  final bool conectado;
  // id_lote numérico (a diferencia de `lote`, que es el nombre legible):
  // necesario para abrir el WebSocket de ws-gateway (GET /ws/lotes/{id})
  // y mostrar las lecturas en vivo de este sensor en su detalle.
  final int? loteId;

  SensorModel({
    this.sensorId,
    required this.nombre,
    required this.tipo,
    required this.codigo,
    required this.lote,
    required this.conectado,
    this.loteId,
  });

  Color get colorEstado =>
      conectado ? Colors.green : Colors.red;

  String get estado =>
      conectado ? "Conectado" : "Desconectado";
}
