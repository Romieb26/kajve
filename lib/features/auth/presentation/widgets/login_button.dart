import 'package:flutter/material.dart';

import '../providers/auth_provider.dart';

class LoginButton extends StatelessWidget {
  final AuthFormState state;
  final AuthController controller;

  const LoginButton({
    super.key,
    required this.state,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: FilledButton.icon(
        icon: state.cargando
            ? const SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.white,
          ),
        )
            : const Icon(Icons.login),
        label: Text(
          state.cargando
              ? "Verificando..."
              : "Iniciar sesión",
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
        onPressed: state.cargando
            ? null
            : () {
          controller.iniciarSesion(context);
        },
      ),
    );
  }
}
