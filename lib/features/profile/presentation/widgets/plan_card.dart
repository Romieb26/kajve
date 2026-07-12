import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/premium_upsell_sheet.dart';
import '../providers/profile_provider.dart';

class PlanCard extends StatelessWidget {
  final ProfileProvider provider;

  const PlanCard({
    super.key,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final perfil = provider.perfil;
    final esPremium = perfil?.esPremium ?? false;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.workspace_premium_outlined, color: theme.colorScheme.primary),
                const SizedBox(width: 10),
                Text("Estado de cuenta", style: theme.textTheme.titleMedium),
              ],
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: esPremium ? AppColors.premium : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    esPremium ? "PREMIUM" : "FREE",
                    style: TextStyle(
                      color: esPremium ? Colors.white : AppColors.textSecondary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Text(
                    esPremium ? "Plan actual: Premium" : "Plan actual: Free",
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            if (esPremium && perfil?.premiumHasta != null) ...[
              const SizedBox(height: 10),
              Text(
                "Vence el ${_formatearFecha(perfil!.premiumHasta!)}",
                style: theme.textTheme.bodySmall,
              ),
            ],

            if (!esPremium) ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.premium,
                  ),
                  onPressed: () => abrirLandingPremium(context),
                  icon: const Icon(Icons.workspace_premium),
                  label: const Text("Actualizar a Premium"),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatearFecha(String iso) {
    final fecha = DateTime.tryParse(iso);
    if (fecha == null) return iso;

    final dia = fecha.day.toString().padLeft(2, '0');
    final mes = fecha.month.toString().padLeft(2, '0');
    return "$dia/$mes/${fecha.year}";
  }
}
