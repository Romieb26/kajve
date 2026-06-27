import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../shared/widgets/app_bottom_navigation.dart';
import '../ providers/profile_provider.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_card.dart';
import '../widgets/password_card.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProfileProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xffB56A1F),

      appBar: AppBar(
        backgroundColor: const Color(0xff6A3C18),
        title: const Text("Mi Perfil"),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            const ProfileHeader(),

            const SizedBox(height: 20),

            ProfileCard(provider: provider),

            const SizedBox(height: 20),

            PasswordCard(provider: provider),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: provider.guardarCambios,
                icon: const Icon(Icons.save),
                label: const Text("Guardar cambios"),
              ),
            ),

          ],
        ),
      ),

      bottomNavigationBar: const AppBottomNavigation(
        currentIndex: 3,
      ),
    );
  }
}