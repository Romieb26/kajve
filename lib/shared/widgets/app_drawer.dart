import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/network/api_client.dart';
import '../../core/routes/app_routes.dart';
import '../../core/storage/secure_storage.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/profile/presentation/providers/profile_provider.dart';
import 'lote_selector_sheet.dart';
import 'premium_upsell_sheet.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    // Mientras el perfil no ha cargado todavía se trata como no-premium
    // (candados visibles) en vez de asumir acceso por defecto.
    final esPremium = context.watch<ProfileProvider>().perfil?.esPremium ?? false;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.brown,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(
                  Icons.coffee,
                  color: Colors.white,
                  size: 48,
                ),
                SizedBox(height: 10),
                Text(
                  "KAJVE",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Sistema Inteligente de Secado",
                  style: TextStyle(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),

          _item(
            context,
            icon: Icons.dashboard,
            title: "Dashboard",
            route: AppRoutes.dashboard,
          ),

          _item(
            context,
            icon: Icons.agriculture,
            title: "Lotes",
            route: AppRoutes.lots,
          ),

          _selectorItem(
            context,
            icon: Icons.monitor_heart,
            title: "Monitoreo",
            route: AppRoutes.lotDetail,
          ),

          _item(
            context,
            icon: Icons.qr_code_scanner,
            title: "Escanear QR",
            route: AppRoutes.qr,
          ),

          _selectorItem(
            context,
            icon: Icons.sensors,
            title: "Tiempo Real",
            route: AppRoutes.realtime,
          ),

          /// NUEVO MÓDULO
          _item(
            context,
            icon: Icons.sensors_outlined,
            title: "Sensores",
            route: AppRoutes.sensors,
          ),

          _selectorItem(
            context,
            icon: Icons.warning_amber,
            title: "Alertas",
            route: AppRoutes.alerts,
          ),

          const Divider(),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Text(
              "PREMIUM",
              style: TextStyle(
                color: AppColors.premium,
                fontWeight: FontWeight.bold,
                fontSize: 12,
                letterSpacing: 1.1,
              ),
            ),
          ),

          _selectorItem(
            context,
            icon: Icons.show_chart,
            title: "Predicciones",
            route: AppRoutes.prediction,
            premium: true,
            esPremium: esPremium,
          ),

          _item(
            context,
            icon: Icons.history,
            title: "Historial",
            route: AppRoutes.history,
            premium: true,
            esPremium: esPremium,
          ),

          _item(
            context,
            icon: Icons.description,
            title: "Reportes",
            route: AppRoutes.reports,
            premium: true,
            esPremium: esPremium,
          ),

          const Divider(),

          _item(
            context,
            icon: Icons.person,
            title: "Perfil",
            route: AppRoutes.profile,
          ),

          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Cerrar sesión"),
            onTap: () async {
              await LogoutUseCase(
                AuthRepositoryImpl(AuthRemoteDataSourceImpl(ApiClient()), SecureStorage()),
              )();

              if (context.mounted) {
                Navigator.pushReplacementNamed(
                  context,
                  AppRoutes.login,
                );
              }
            },
          ),
        ],
      ),
    );
  }

  static Widget _item(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String route,
        bool premium = false,
        bool esPremium = false,
      }) {
    final bloqueado = premium && !esPremium;

    return ListTile(
      leading: Icon(icon, color: bloqueado ? AppColors.premium : null),
      title: _titulo(title, bloqueado),
      onTap: () {
        Navigator.pop(context);

        if (bloqueado) {
          showPremiumUpsell(context);
          return;
        }

        Navigator.pushReplacementNamed(
          context,
          route,
        );
      },
    );
  }

  /// Igual que [_item], pero para rutas que necesitan un lote
  /// específico (monitoreo, tiempo real) y no tienen uno en contexto:
  /// primero muestra un selector de lotes en vez de navegar directo.
  static Widget _selectorItem(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String route,
        bool premium = false,
        bool esPremium = false,
      }) {
    final bloqueado = premium && !esPremium;

    return ListTile(
      leading: Icon(icon, color: bloqueado ? AppColors.premium : null),
      title: _titulo(title, bloqueado),
      onTap: () {
        Navigator.pop(context);

        if (bloqueado) {
          showPremiumUpsell(context);
          return;
        }

        showLoteSelector(context, route: route);
      },
    );
  }

  /// Título del ítem. Cuando está bloqueado por no ser premium, se
  /// pinta en morado y se le agrega un candado, para distinguirlo del
  /// resto de opciones antes de que el usuario intente entrar.
  static Widget _titulo(String title, bool bloqueado) {
    if (!bloqueado) return Text(title);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.premium,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 6),
        const Icon(Icons.lock, size: 14, color: AppColors.premium),
      ],
    );
  }
}
