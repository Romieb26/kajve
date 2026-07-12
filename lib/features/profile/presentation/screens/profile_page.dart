import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../shared/widgets/app_drawer.dart';

import '../../../../core/theme/theme_provider.dart';

import '../providers/profile_provider.dart';
import '../widgets/profile_header.dart';
import '../widgets/plan_card.dart';
import '../widgets/profile_card.dart';
import '../widgets/password_card.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileProvider>().cargarPerfil();
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return Consumer<ProfileProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          drawer: const AppDrawer(),

          appBar: AppBar(
            title: const Text("Mi Perfil"),
            centerTitle: true,
          ),

          body: _buildBody(context, provider, themeProvider),
        );
      },
    );
  }

  Widget _buildBody(
    BuildContext context,
    ProfileProvider provider,
    ThemeProvider themeProvider,
  ) {
    final theme = Theme.of(context);

    if (provider.cargando && provider.perfil == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.errorMessage != null && provider.perfil == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.cloud_off, size: 48, color: theme.textTheme.bodySmall?.color),
              const SizedBox(height: 12),
              Text(
                provider.errorMessage!,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: provider.cargarPerfil,
                child: const Text("Reintentar"),
              ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [

          /// Cabecera
          const ProfileHeader(),

          const SizedBox(height: 20),

          /// Plan / estado de suscripción
          PlanCard(provider: provider),

          const SizedBox(height: 20),

          /// Información personal
          ProfileCard(provider: provider),

          const SizedBox(height: 20),

          /// Cambiar contraseña
          PasswordCard(provider: provider),

          const SizedBox(height: 20),

          /// Modo claro / oscuro
          Card(
            child: SwitchListTile(
              value: themeProvider.modoOscuro,
              onChanged: themeProvider.cambiarTema,
              title: const Text("Modo oscuro"),
              subtitle: const Text(
                "Cambia el tema manualmente, sin depender del sistema.",
              ),
              secondary: Icon(
                themeProvider.modoOscuro
                    ? Icons.dark_mode
                    : Icons.light_mode,
              ),
            ),
          ),

          const SizedBox(height: 25),

          /// Cerrar sesión
          OutlinedButton.icon(
            onPressed: () {
              provider.cerrarSesion(context);
            },
            icon: const Icon(Icons.logout),
            label: const Text("Cerrar sesión"),
          ),
        ],
      ),
    );
  }
}