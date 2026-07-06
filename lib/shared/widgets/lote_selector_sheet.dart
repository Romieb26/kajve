import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../features/lots/presentation/providers/lot_provider.dart';

/// Muestra una hoja modal para elegir un lote y navega a [route]
/// pasando su id real como argumento. Se usa en los accesos que no
/// tienen contexto de un lote específico (drawer, accesos rápidos del
/// dashboard) — a diferencia de tocar una card en la lista de lotes,
/// donde el id ya se conoce de antemano.
Future<void> showLoteSelector(
  BuildContext context, {
  required String route,
}) async {
  final lotProvider = Provider.of<LotProvider>(context, listen: false);
  final lotes = lotProvider.lotes;

  if (lotes.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("No tienes lotes registrados aún.")),
    );
    return;
  }

  await showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (sheetContext) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                "Selecciona un lote",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            for (final lote in lotes)
              ListTile(
                leading: Icon(
                  Icons.grass,
                  color: lote.id != null ? null : Colors.grey,
                ),
                title: Text(lote.nombre),
                subtitle: lote.id != null
                    ? null
                    : const Text("Sin datos de monitoreo disponibles"),
                enabled: lote.id != null,
                onTap: lote.id == null
                    ? null
                    : () {
                        Navigator.pop(sheetContext);
                        Navigator.pushNamed(
                          context,
                          route,
                          arguments: lote.id,
                        );
                      },
              ),

            const SizedBox(height: 8),
          ],
        ),
      );
    },
  );
}
