import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/profile_provider.dart';


class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProfileProvider>(context);
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
          provider.nombreController.text,
          style: theme.textTheme.titleLarge?.copyWith(fontSize: 24),
        ),

        const SizedBox(height: 5),

        Text(
          provider.correoController.text,
          style: theme.textTheme.bodyMedium?.copyWith(fontSize: 16),
        ),

      ],
    );
  }
}