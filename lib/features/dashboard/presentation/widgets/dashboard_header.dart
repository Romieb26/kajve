import 'package:flutter/material.dart';

class DashboardHeader extends StatelessWidget {
  final String nombre;

  const DashboardHeader({
    super.key,
    required this.nombre,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [

            const CircleAvatar(
              radius: 35,
              child: Icon(
                Icons.person,
                size: 35,
              ),
            ),

            const SizedBox(width: 20),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const Text(
                    "Bienvenido",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),

                  Text(
                    nombre,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  const Text(
                    "Sistema Inteligente KAJVE",
                    style: TextStyle(
                      color: Colors.brown,
                    ),
                  ),

                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}