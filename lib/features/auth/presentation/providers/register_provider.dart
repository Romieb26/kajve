import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/usecases/register_usecase.dart';

part 'register_provider.g.dart';

class RegisterFormState {
  final bool ocultarPassword;
  final bool ocultarConfirmacion;
  final bool cargando;

  const RegisterFormState({
    this.ocultarPassword = true,
    this.ocultarConfirmacion = true,
    this.cargando = false,
  });

  RegisterFormState copyWith({
    bool? ocultarPassword,
    bool? ocultarConfirmacion,
    bool? cargando,
  }) {
    return RegisterFormState(
      ocultarPassword: ocultarPassword ?? this.ocultarPassword,
      ocultarConfirmacion: ocultarConfirmacion ?? this.ocultarConfirmacion,
      cargando: cargando ?? this.cargando,
    );
  }
}

@riverpod
class RegisterController extends _$RegisterController {
  final nombreController = TextEditingController();
  final correoController = TextEditingController();
  final telefonoController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmarController = TextEditingController();

  @override
  RegisterFormState build() {
    ref.onDispose(() {
      nombreController.dispose();
      correoController.dispose();
      telefonoController.dispose();
      passwordController.dispose();
      confirmarController.dispose();
    });
    return const RegisterFormState();
  }

  void cambiarPassword() {
    state = state.copyWith(ocultarPassword: !state.ocultarPassword);
  }

  void cambiarConfirmacion() {
    state = state.copyWith(ocultarConfirmacion: !state.ocultarConfirmacion);
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

    state = state.copyWith(cargando: true);

    try {
      await getIt<RegisterUseCase>()(
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
      state = state.copyWith(cargando: false);
    }
  }

  void _mostrarSnackBar(BuildContext context, String mensaje, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje), backgroundColor: color),
    );
  }
}
