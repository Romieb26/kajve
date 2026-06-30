import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../shared/widgets/app_bottom_navigation.dart';
import '../../../../shared/widgets/app_drawer.dart';

import '../ providers/profile_provider.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_card.dart';
import '../widgets/password_card.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: const Color(0xffB56A1F),

          drawer: const AppDrawer(),

          appBar: AppBar(
            backgroundColor: const Color(0xff6A3C18),
            title: const Text("Mi Perfil"),
            centerTitle: true,
          ),

          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [

                /// Cabecera
                const ProfileHeader(),

                const SizedBox(height: 20),

                /// Información personal
                ProfileCard(provider: provider),

                const SizedBox(height: 20),

                /// Cambiar contraseña
                PasswordCard(provider: provider),

                const SizedBox(height: 25),

                /// Guardar cambios
                FilledButton.icon(
                  onPressed: provider.guardarCambios,
                  icon: const Icon(Icons.save),
                  label: const Text("Guardar cambios"),
                ),

                const SizedBox(height: 15),

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
          ),

          bottomNavigationBar: const AppBottomNavigation(
            currentIndex: 4,
          ),
        );
      },
    );
  }
}