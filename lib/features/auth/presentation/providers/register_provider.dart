import 'package:flutter/material.dart';

class RegisterProvider extends ChangeNotifier {
  final nombreController = TextEditingController();
  final correoController = TextEditingController();
  final usuarioController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmarController = TextEditingController();

  bool ocultarPassword = true;
  bool ocultarConfirmacion = true;

  bool cargando = false;

  void cambiarPassword() {
    ocultarPassword = !ocultarPassword;
    notifyListeners();
  }

  void cambiarConfirmacion() {
    ocultarConfirmacion = !ocultarConfirmacion;
    notifyListeners();
  }

  Future<void> registrar(BuildContext context) async {

    if (nombreController.text.isEmpty ||
        correoController.text.isEmpty ||
        usuarioController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmarController.text.isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Completa todos los campos."),
        ),
      );
      return;
    }

    if (passwordController.text != confirmarController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Las contraseñas no coinciden."),
        ),
      );
      return;
    }

    cargando = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));

    cargando = false;
    notifyListeners();

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Usuario registrado correctamente."),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    nombreController.dispose();
    correoController.dispose();
    usuarioController.dispose();
    passwordController.dispose();
    confirmarController.dispose();
    super.dispose();
  }
}