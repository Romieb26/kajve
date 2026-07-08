import 'package:flutter/material.dart';

import '../providers/alerts_provider.dart';

class AlertFilter extends StatelessWidget {
  final AlertsProvider provider;

  const AlertFilter({
    super.key,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {

    final filtros = [
      "Todas",
      "alta",
      "media",
      "baja",
      "critica",
    ];

    return Wrap(
      spacing: 10,
      children: filtros.map((filtro) {

        return ChoiceChip(

          label: Text(filtro),

          selected: provider.filtro == filtro,

          onSelected: (_) {
            provider.filtrar(filtro);
          },

        );

      }).toList(),
    );
  }
}