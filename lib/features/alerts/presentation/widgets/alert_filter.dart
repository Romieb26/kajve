import 'package:flutter/material.dart';

import '../providers/alerts_provider.dart';

class AlertFilter extends StatelessWidget {
  final AlertsState state;
  final AlertsController controller;

  const AlertFilter({
    super.key,
    required this.state,
    required this.controller,
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

          selected: state.filtro == filtro,

          onSelected: (_) {
            controller.filtrar(filtro);
          },

        );

      }).toList(),
    );
  }
}