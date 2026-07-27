import 'package:flutter/material.dart';

import '../providers/register_provider.dart';

class RegisterForm extends StatelessWidget {
  final RegisterFormState state;
  final RegisterController controller;

  const RegisterForm({
    super.key,
    required this.state,
    required this.controller,
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
              controller: controller.nombreController,
              decoration: const InputDecoration(
                labelText: "Nombre completo",
                prefixIcon: Icon(Icons.person),
              ),
            ),

            const SizedBox(height: 18),

            TextField(
              controller: controller.correoController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: "Correo electrónico",
                prefixIcon: Icon(Icons.email),
              ),
            ),

            const SizedBox(height: 18),

            TextField(
              controller: controller.telefonoController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: "Teléfono",
                prefixIcon: Icon(Icons.phone),
              ),
            ),

            const SizedBox(height: 18),

            TextField(
              controller: controller.passwordController,
              obscureText: state.ocultarPassword,
              decoration: InputDecoration(
                labelText: "Contraseña",
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(
                    state.ocultarPassword
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: controller.cambiarPassword,
                ),
              ),
            ),

            const SizedBox(height: 18),

            TextField(
              controller: controller.confirmarController,
              obscureText: state.ocultarConfirmacion,
              decoration: InputDecoration(
                labelText: "Confirmar contraseña",
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(
                    state.ocultarConfirmacion
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: controller.cambiarConfirmacion,
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
