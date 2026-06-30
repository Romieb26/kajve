import 'package:flutter/material.dart';

import '../providers/auth_provider.dart';

class LoginButton extends StatelessWidget {
  final AuthProvider provider;

  const LoginButton({
    super.key,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: FilledButton.icon(
        icon: provider.cargando
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
          provider.cargando
              ? "Verificando..."
              : "Iniciar sesión",
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
        onPressed: provider.cargando
            ? null
            : () {
          provider.iniciarSesion(context);
        },
      ),
    );
  }
}