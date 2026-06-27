import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [

        CircleAvatar(
          radius: 55,
          backgroundColor: Colors.white,
          child: Icon(
            Icons.person,
            size: 60,
            color: Colors.brown,
          ),
        ),

        SizedBox(height: 12),

        Text(
          "Mi Perfil",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),

      ],
    );
  }
}