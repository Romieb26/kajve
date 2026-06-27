import 'package:flutter/material.dart';

import '../providers/auth_provider.dart';

class LoginForm extends StatelessWidget {
  final AuthProvider provider;

  const LoginForm({
    super.key,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            TextField(
              controller: provider.usernameController,
              decoration: const InputDecoration(
                labelText: "Usuario",
                prefixIcon: Icon(Icons.person),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: provider.passwordController,
              obscureText: provider.ocultarPassword,
              decoration: InputDecoration(
                labelText: "Contraseña",
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(
                    provider.ocultarPassword
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: provider.cambiarVisibilidad,
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}