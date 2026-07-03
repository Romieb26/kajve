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
              controller: provider.emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: "Correo electrónico",
                prefixIcon: const Icon(Icons.email),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: provider.passwordController,
              obscureText: provider.ocultarPassword,
              enableSuggestions: false,
              autocorrect: false,
              decoration: InputDecoration(
                labelText: "Contraseña",
                prefixIcon: const Icon(Icons.lock),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
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
