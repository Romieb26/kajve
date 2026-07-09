import 'package:flutter/material.dart';

import '../providers/profile_provider.dart';

class ProfileCard extends StatelessWidget {
  final ProfileProvider provider;

  const ProfileCard({
    super.key,
    required this.provider,
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
              controller: provider.nombreController,
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
              controller: provider.correoController,
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
              controller: provider.telefonoController,
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
                onPressed: provider.guardando
                    ? null
                    : () => provider.guardarCambios(context),
                icon: provider.guardando
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save),
                label: Text(
                  provider.guardando ? "Guardando..." : "Guardar cambios",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}