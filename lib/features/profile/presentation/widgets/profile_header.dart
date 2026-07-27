import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/profile_provider.dart';

class ProfileHeader extends ConsumerWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // watch (no solo read) para que este header se redibuje cuando
    // cargarPerfil() termine y llene los controladores.
    ref.watch(profileControllerProvider);
    final controller = ref.read(profileControllerProvider.notifier);
    final theme = Theme.of(context);

    return Column(
      children: [

        CircleAvatar(
          radius: 55,
          backgroundColor: theme.colorScheme.primary.withValues(alpha: .15),
          child: Icon(
            Icons.person,
            size: 60,
            color: theme.colorScheme.primary,
          ),
        ),

        const SizedBox(height: 15),

        Text(
          controller.nombreController.text,
          style: theme.textTheme.titleLarge?.copyWith(fontSize: 24),
        ),

        const SizedBox(height: 5),

        Text(
          controller.correoController.text,
          style: theme.textTheme.bodyMedium?.copyWith(fontSize: 16),
        ),

      ],
    );
  }
}
