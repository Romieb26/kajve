import 'package:flutter/material.dart';

import '../providers/profile_provider.dart';

class ProfileCard extends StatelessWidget {
  final ProfileState state;
  final ProfileController controller;

  const ProfileCard({
    super.key,
    required this.state,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.badge_outlined, color: theme.colorScheme.primary),
                const SizedBox(width: 10),
                Text("Información personal", style: theme.textTheme.titleMedium),
              ],
            ),

            const SizedBox(height: 20),

            TextField(
              controller: controller.nombreController,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                labelText: "Nombre",
                prefixIcon: const Icon(Icons.person),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: controller.correoController,
              readOnly: true,
              enabled: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: "Correo electrónico",
                helperText: "El correo no se puede modificar.",
                prefixIcon: const Icon(Icons.email),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: controller.telefonoController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: "Teléfono",
                prefixIcon: const Icon(Icons.phone),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: state.guardando
                    ? null
                    : () => controller.guardarCambios(context),
                icon: state.guardando
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save),
                label: Text(
                  state.guardando ? "Guardando..." : "Guardar cambios",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
