import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../ providers/profile_provider.dart';


class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProfileProvider>(context);

    return Column(
      children: [

        const CircleAvatar(
          radius: 55,
          backgroundColor: Colors.white,
          child: Icon(
            Icons.person,
            size: 60,
            color: Colors.brown,
          ),
        ),

        const SizedBox(height: 15),

        Text(
          provider.nombreController.text,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),

        const SizedBox(height: 5),

        Text(
          provider.correoController.text,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 16,
          ),
        ),

      ],
    );
  }
}