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

  // Se captura el Navigator ahora, mientras el context todavía es
  // válido con certeza. El Drawer que suele disparar este selector se
  // cierra justo antes de llamar aquí (ver app_drawer.dart), y para
  // cuando el usuario termina de elegir un lote en el modal, ese
  // context puede haber quedado inválido; el NavigatorState capturado
  // no depende de que el context original siga vivo.
  final navigator = Navigator.of(context);

  if (lotProvider.cargandoLotes) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Cargando lotes, intenta de nuevo en un momento.")),
    );
    return;
  }

  final lotes = lotProvider.lotes;

  if (lotes.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("No tienes lotes registrados aún.")),
    );
    return;
  }

  // Se espera a que el modal cierre por completo (devolviendo el id
  // elegido) antes de navegar. Hacer el pop del modal y el push de la
  // nueva pantalla en el mismo tap producía una carrera con la
  // animación de cierre y la navegación se perdía silenciosamente.
  final loteId = await showModalBottomSheet<int>(
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
                leading: const Icon(Icons.grass),
                title: Text(lote.nombre),
                onTap: () => Navigator.pop(sheetContext, lote.id),
              ),

            const SizedBox(height: 8),
          ],
        ),
      );
    },
  );

  if (loteId == null) return;

  navigator.pushNamed(route, arguments: loteId);
}
