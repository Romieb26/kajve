import 'package:flutter/material.dart';

import '../providers/realtime_provider.dart';

class EnvironmentCard extends StatelessWidget {
  final RealtimeProvider provider;

  const EnvironmentCard({
    super.key,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,

      child: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            const Text(
              "Estado General",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const Divider(),

            ListTile(
              leading: const Icon(
                Icons.check_circle,
                color: Colors.green,
              ),

              title: Text(provider.estado),
            ),

            ListTile(
              leading: const Icon(Icons.sunny),

              title: const Text("Radiación"),

              trailing: Text(
                "${provider.radiacion} W/m²",
              ),
            ),

          ],
        ),
      ),
    );
  }
}