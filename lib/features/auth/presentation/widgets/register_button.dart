import 'package:flutter/material.dart';

import '../providers/register_provider.dart';

class RegisterButton extends StatelessWidget {
  final RegisterFormState state;
  final RegisterController controller;

  const RegisterButton({
    super.key,
    required this.state,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: FilledButton.icon(
        onPressed: state.cargando
            ? null
            : () => controller.registrar(context),

        icon: state.cargando
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
          state.cargando
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
