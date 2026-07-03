import 'package:flutter/material.dart';

import '../providers/register_provider.dart';

class RegisterForm extends StatelessWidget {
  final RegisterProvider provider;

  const RegisterForm({
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
              controller: provider.nombreController,
              decoration: const InputDecoration(
                labelText: "Nombre completo",
                prefixIcon: Icon(Icons.person),
              ),
            ),

            const SizedBox(height: 18),

            TextField(
              controller: provider.correoController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: "Correo electrónico",
                prefixIcon: Icon(Icons.email),
              ),
            ),

            const SizedBox(height: 18),

            TextField(
              controller: provider.telefonoController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: "Teléfono",
                prefixIcon: Icon(Icons.phone),
              ),
            ),

            const SizedBox(height: 18),

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
                  onPressed: provider.cambiarPassword,
                ),
              ),
            ),

            const SizedBox(height: 18),

            TextField(
              controller: provider.confirmarController,
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
                  onPressed: provider.cambiarConfirmacion,
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
