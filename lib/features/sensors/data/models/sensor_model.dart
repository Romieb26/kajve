import 'package:flutter/material.dart';

class SensorModel {
  final String nombre;
  final String tipo;
  final String codigo;
  final String lote;
  final bool conectado;

  SensorModel({
    required this.nombre,
    required this.tipo,
    required this.codigo,
    required this.lote,
    required this.conectado,
  });

  Color get colorEstado =>
      conectado ? Colors.green : Colors.red;

  String get estado =>
      conectado ? "Conectado" : "Desconectado";
}