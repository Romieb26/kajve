import 'package:flutter/material.dart';

class ProfileProvider extends ChangeNotifier {
  final TextEditingController nombreController =
  TextEditingController(text: "Juan Pérez");

  final TextEditingController correoController =
  TextEditingController(text: "juan@email.com");

  final TextEditingController telefonoController =
  TextEditingController(text: "9611234567");

  final TextEditingController passwordController =
  TextEditingController();

  final TextEditingController confirmPasswordController =
  TextEditingController();

  bool ocultarPassword = true;
  bool ocultarConfirmacion = true;

  void cambiarVisibilidadPassword() {
    ocultarPassword = !ocultarPassword;
    notifyListeners();
  }

  void cambiarVisibilidadConfirmacion() {
    ocultarConfirmacion = !ocultarConfirmacion;
    notifyListeners();
  }

  void guardarCambios() {
    notifyListeners();
  }
}