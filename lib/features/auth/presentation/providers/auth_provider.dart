import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {

  final TextEditingController usernameController =
  TextEditingController();

  final TextEditingController passwordController =
  TextEditingController();

  bool ocultarPassword = true;

  void cambiarVisibilidad() {
    ocultarPassword = !ocultarPassword;
    notifyListeners();
  }

  void iniciarSesion(BuildContext context) {
    if (usernameController.text.isEmpty ||
        passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Complete todos los campos"),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Inicio de sesión correcto"),
      ),
    );

    // Aquí posteriormente navegarás al Dashboard.
    // Navigator.pushReplacement(...);
  }
}