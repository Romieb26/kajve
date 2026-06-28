import 'package:flutter/material.dart';

class DryingStatusCard extends StatelessWidget {
  final String estado;
  final Color color;

  const DryingStatusCard({
    super.key,
    required this.estado,
    required this.color,
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

        child: Column(
          children: [

            const Text(
              "Estado del Secado",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            CircleAvatar(
              radius: 35,
              backgroundColor: color.withOpacity(.15),
              child: Icon(
                Icons.check_circle,
                color: color,
                size: 40,
              ),
            ),

            const SizedBox(height: 15),

            Text(
              estado,
              style: TextStyle(
                fontSize: 22,
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}