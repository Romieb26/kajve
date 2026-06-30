import 'package:flutter/material.dart';

import '../providers/sensor_provider.dart';

class SearchSensor extends StatelessWidget {
  final SensorProvider provider;

  const SearchSensor({
    super.key,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: provider.searchController,
      onChanged: provider.buscar,
      decoration: InputDecoration(
        hintText: "Buscar sensor...",
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}