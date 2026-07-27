import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/widgets/app_drawer.dart';

import '../../../../core/theme/theme_provider.dart';

import '../providers/profile_provider.dart';
import '../widgets/profile_header.dart';
import '../widgets/plan_card.dart';
import '../widgets/profile_card.dart';
import '../widgets/password_card.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(profileControllerProvider.notifier).cargarPerfil();
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeControllerProvider);
    final themeController = ref.read(themeModeControllerProvider.notifier);
    final state = ref.watch(profileControllerProvider);
    final controller = ref.read(profileControllerProvider.notifier);

    return Scaffold(
      drawer: const AppDrawer(),

      appBar: AppBar(
        title: const Text("Mi Perfil"),
        centerTitle: true,
      ),

      body: _buildBody(context, state, controller, themeMode, themeController),
    );
  }

  Widget _buildBody(
    BuildContext context,
    ProfileState state,
    ProfileController controller,
    ThemeMode themeMode,
    ThemeModeController themeController,
  ) {
    final theme = Theme.of(context);
    final modoOscuro = themeMode == ThemeMode.dark;

    if (state.cargando && state.perfil == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.errorMessage != null && state.perfil == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.cloud_off, size: 48, color: theme.textTheme.bodySmall?.color),
              const SizedBox(height: 12),
              Text(
                state.errorMessage!,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: controller.cargarPerfil,
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
          PlanCard(state: state),

          const SizedBox(height: 20),

          /// Información personal
          ProfileCard(state: state, controller: controller),

          const SizedBox(height: 20),

          /// Cambiar contraseña
          PasswordCard(state: state, controller: controller),

          const SizedBox(height: 20),

          /// Modo claro / oscuro
          Card(
            child: SwitchListTile(
              value: modoOscuro,
              onChanged: themeController.cambiarTema,
              title: const Text("Modo oscuro"),
              subtitle: const Text(
                "Cambia el tema manualmente, sin depender del sistema.",
              ),
              secondary: Icon(
                modoOscuro ? Icons.dark_mode : Icons.light_mode,
              ),
            ),
          ),

          const SizedBox(height: 25),

          /// Cerrar sesión
          OutlinedButton.icon(
            onPressed: () {
              controller.cerrarSesion(context);
            },
            icon: const Icon(Icons.logout),
            label: const Text("Cerrar sesión"),
          ),
        ],
      ),
    );
  }
}
