import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/premium_upsell_sheet.dart';

/// Banner discreto que invita a actualizar a Premium. Solo debe
/// mostrarse cuando el usuario no es premium (lo decide quien lo usa).
class PremiumBanner extends StatelessWidget {
  final VoidCallback onClose;

  const PremiumBanner({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.premiumBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.premium.withValues(alpha: .35)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.workspace_premium, color: AppColors.premium),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Desbloquea Predicciones, Historial y Reportes",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.premium,
                  ),
                ),

                const SizedBox(height: 4),

                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      foregroundColor: AppColors.premium,
                    ),
                    onPressed: () => abrirLandingPremium(context),
                    child: const Text("Actualizar a Premium"),
                  ),
                ),
              ],
            ),
          ),

          IconButton(
            icon: const Icon(Icons.close, size: 18),
            color: AppColors.premium,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: onClose,
          ),
        ],
      ),
    );
  }
}
