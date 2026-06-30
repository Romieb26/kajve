import 'package:flutter/material.dart';

import '../ providers/profile_provider.dart';

class PasswordCard extends StatelessWidget {
  final ProfileProvider provider;

  const PasswordCard({
    super.key,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Cambiar contraseña",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              "Utiliza una contraseña segura de al menos 8 caracteres.",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 13,
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: provider.passwordController,
              obscureText: provider.ocultarPassword,
              enableSuggestions: false,
              autocorrect: false,
              decoration: InputDecoration(
                labelText: "Nueva contraseña",
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
                  onPressed: provider.cambiarVisibilidadPassword,
                ),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: provider.confirmPasswordController,
              obscureText: provider.ocultarConfirmacion,
              enableSuggestions: false,
              autocorrect: false,
              decoration: InputDecoration(
                labelText: "Confirmar contraseña",
                prefixIcon: const Icon(Icons.lock_outline),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    provider.ocultarConfirmacion
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed:
                  provider.cambiarVisibilidadConfirmacion,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}