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
        hintText: "Buscar evento...",
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          ),
        ),
      ),
    );
  }
}