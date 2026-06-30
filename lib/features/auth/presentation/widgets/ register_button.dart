import 'package:flutter/material.dart';

import '../providers/register_provider.dart';

class RegisterButton extends StatelessWidget {
  final RegisterProvider provider;

  const RegisterButton({
    super.key,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: FilledButton.icon(
        onPressed: provider.cargando
            ? null
            : () => provider.registrar(context),

        icon: provider.cargando
            ? const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.white,
          ),
        )
            : const Icon(Icons.person_add),

        label: Text(
          provider.cargando
              ? "Registrando..."
              : "Registrarse",
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}