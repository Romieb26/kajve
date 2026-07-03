import 'package:flutter/material.dart';

import '../../../../core/routes/app_routes.dart';


class AuthProvider extends ChangeNotifier {
  final TextEditingController usuarioController =
  TextEditingController();

  final TextEditingController passwordController =
  TextEditingController();

  bool ocultarPassword = true;
  bool cargando = false;

  void cambiarVisibilidad() {
    ocultarPassword = !ocultarPassword;
    notifyListeners();
  }

  Future<void> iniciarSesion(BuildContext context) async {
    final usuario = usuarioController.text.trim();
    final password = passwordController.text.trim();

    if (usuario.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Completa todos los campos."),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    cargando = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));

    const usuarioAdmin = "admin";
    const passwordAdmin = "123456";

    if (usuario == usuarioAdmin &&
        password == passwordAdmin) {

      if (context.mounted) {
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.dashboard,
        );
      }

    } else {

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Usuario o contraseña incorrectos."),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    cargando = false;
    notifyListeners();
  }

  @override
  void dispose() {
    usuarioController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}