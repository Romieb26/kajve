import 'package:flutter/material.dart';

class ProfileProvider extends ChangeNotifier {
  /// Controladores
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

  /// Estadísticas
  int totalLotes = 18;
  int totalPredicciones = 72;
  int totalAlertas = 12;

  /// Configuración
  bool ocultarPassword = true;
  bool ocultarConfirmacion = true;
  bool modoOscuro = false;

  /// Mostrar/Ocultar contraseña
  void cambiarVisibilidadPassword() {
    ocultarPassword = !ocultarPassword;
    notifyListeners();
  }

  /// Mostrar/Ocultar confirmación
  void cambiarVisibilidadConfirmacion() {
    ocultarConfirmacion = !ocultarConfirmacion;
    notifyListeners();
  }

  /// Cambiar tema
  void cambiarTema(bool value) {
    modoOscuro = value;
    notifyListeners();
  }

  /// Guardar cambios
  void guardarCambios() {
    // Aquí después irá la llamada a la API.
    notifyListeners();
  }

  /// Cerrar sesión
  void cerrarSesion(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Sesión cerrada"),
      ),
    );

    // Más adelante aquí navegaremos al Login.
  }

  @override
  void dispose() {
    nombreController.dispose();
    correoController.dispose();
    telefonoController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}