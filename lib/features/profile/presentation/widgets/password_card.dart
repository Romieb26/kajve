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

            const SizedBox(height: 15),

            TextField(
              controller: provider.passwordController,
              obscureText: provider.ocultarPassword,
              decoration: InputDecoration(
                labelText: "Nueva contraseña",
                prefixIcon: const Icon(Icons.lock),
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

            const SizedBox(height: 15),

            TextField(
              controller: provider.confirmPasswordController,
              obscureText: provider.ocultarConfirmacion,
              decoration: InputDecoration(
                labelText: "Confirmar contraseña",
                prefixIcon: const Icon(Icons.lock_outline),
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