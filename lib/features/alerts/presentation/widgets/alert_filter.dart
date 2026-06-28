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
    return Row(
      children: [

        _btn("Todas"),
        const SizedBox(width: 8),
        _btn("alta"),
        const SizedBox(width: 8),
        _btn("media"),

      ],
    );
  }

  Widget _btn(String texto) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () => provider.filtrar(texto),
        child: Text(texto),
      ),
    );
  }
}