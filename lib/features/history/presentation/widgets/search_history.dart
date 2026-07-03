import 'package:flutter/material.dart';

import '../providers/history_provider.dart';

class SearchHistory extends StatelessWidget {
  final HistoryProvider provider;

  const SearchHistory({
    super.key,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: provider.searchController,
      onChanged: provider.buscar,
      decoration: InputDecoration(
        hintText: "Buscar lote...",
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}