import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/widgets/app_drawer.dart';

import '../providers/lot_provider.dart';
import '../widgets/create_lot_form.dart';
import '../widgets/sensor_card.dart';
import '../widgets/qr_preview.dart';

class CreateLotPage extends ConsumerWidget {
  const CreateLotPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(lotControllerProvider);
    final controller = ref.read(lotControllerProvider.notifier);

    return Scaffold(
      drawer: const AppDrawer(),

      appBar: AppBar(
        title: const Text("Registrar Lote"),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            /// Formulario
            const CreateLotForm(),

            const SizedBox(height: 20),

            /// Sensores
            const SensorCard(),

            const SizedBox(height: 20),

            /// QR
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: QrPreview(codigoQr: state.codigoQrGenerado),
              ),
            ),

            if (state.codigoQrGenerado != null) ...[
              const SizedBox(height: 15),

              FilledButton.icon(
                onPressed: () {
                  controller.ocultarQr();
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.check_circle),
                label: const Text("Volver a Lotes"),
              ),
            ],

            const SizedBox(height: 25),

            FilledButton.icon(
              onPressed: state.cargando
                  ? null
                  : () {
                      controller.registrarLote(context);
                    },
              icon: state.cargando
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.save),
              label: Text(
                state.cargando ? "Guardando..." : "Guardar lote",
              ),
            ),

            const SizedBox(height: 20),

          ],
        ),
      ),
    );
  }
}
