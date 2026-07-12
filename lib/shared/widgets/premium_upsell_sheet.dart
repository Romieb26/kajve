import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/constants/app_colors.dart';

/// Landing de actualización a Premium.
const String kPremiumLandingUrl = 'https://landing-cafe-8vji.vercel.app';

/// Abre [kPremiumLandingUrl] en el navegador del celular.
Future<void> abrirLandingPremium(BuildContext context) async {
  final messenger = ScaffoldMessenger.of(context);

  final abierto = await launchUrl(
    Uri.parse(kPremiumLandingUrl),
    mode: LaunchMode.externalApplication,
  );

  if (!abierto) {
    messenger.showSnackBar(
      const SnackBar(content: Text("No se pudo abrir el enlace.")),
    );
  }
}

/// Bottom sheet que se muestra cuando un usuario no-premium intenta
/// entrar a una función premium (Predicciones, Historial, Reportes).
Future<void> showPremiumUpsell(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (sheetContext) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.workspace_premium,
                size: 48,
                color: AppColors.premium,
              ),

              const SizedBox(height: 16),

              const Text(
                "Función Premium",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                "Esta función está disponible solo para cuentas Premium. "
                "Actualiza tu plan para desbloquearla.",
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textSecondary),
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.premium,
                  ),
                  onPressed: () {
                    Navigator.pop(sheetContext);
                    abrirLandingPremium(context);
                  },
                  icon: const Icon(Icons.workspace_premium),
                  label: const Text("Actualizar a Premium"),
                ),
              ),

              const SizedBox(height: 8),

              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.pop(sheetContext),
                  child: const Text("Ahora no"),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
