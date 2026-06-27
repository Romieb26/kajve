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
        icon: const Icon(Icons.login),
        label: const Text(
          "Iniciar sesión",
          style: TextStyle(fontSize: 18),
        ),
        onPressed: () {
          provider.iniciarSesion(context);
        },
      ),
    );
  }
}