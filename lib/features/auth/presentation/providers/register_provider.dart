import 'package:flutter/material.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/usecases/register_usecase.dart';

class RegisterProvider extends ChangeNotifier {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController correoController = TextEditingController();
  final TextEditingController telefonoController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmarController = TextEditingController();

  bool ocultarPassword = true;
  bool ocultarConfirmacion = true;
  bool cargando = false;

  late final RegisterUseCase _registerUseCase = RegisterUseCase(
    AuthRepositoryImpl(
      AuthRemoteDataSourceImpl(ApiClient()),
      SecureStorage(),
    ),
  );

  void cambiarPassword() {
    ocultarPassword = !ocultarPassword;
    notifyListeners();
  }

  void cambiarConfirmacion() {
    ocultarConfirmacion = !ocultarConfirmacion;
    notifyListeners();
  }

  bool _esEmailValido(String email) =>
      email.contains('@') && email.contains('.');

  Future<void> registrar(BuildContext context) async {
    if (nombreController.text.isEmpty ||
        correoController.text.isEmpty ||
        telefonoController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmarController.text.isEmpty) {
      _mostrarSnackBar(context, "Completa todos los campos.", Colors.orange);
      return;
    }

    if (!_esEmailValido(correoController.text.trim())) {
      _mostrarSnackBar(
        context,
        "Ingresa un correo electrónico válido.",
        Colors.orange,
      );
      return;
    }

    if (passwordController.text != confirmarController.text) {
      _mostrarSnackBar(
        context,
        "Las contraseñas no coinciden.",
        Colors.orange,
      );
      return;
    }

    cargando = true;
    notifyListeners();

    try {
      await _registerUseCase(
        nombre: nombreController.text.trim(),
        email: correoController.text.trim(),
        password: passwordController.text,
        telefono: telefonoController.text.trim(),
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Cuenta creada correctamente."),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pop(context);
      }
    } on ApiException catch (e) {
      if (context.mounted) {
        final mensaje = e.statusCode == 409
            ? "Este correo ya está registrado"
            : "No se pudo completar el registro";
        _mostrarSnackBar(context, mensaje, Colors.red);
      }
    } finally {
      cargando = false;
      notifyListeners();
    }
  }

  void _mostrarSnackBar(BuildContext context, String mensaje, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje), backgroundColor: color),
    );
  }

  @override
  void dispose() {
    nombreController.dispose();
    correoController.dispose();
    telefonoController.dispose();
    passwordController.dispose();
    confirmarController.dispose();
    super.dispose();
  }
}
