import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../shared/widgets/app_drawer.dart';

import '../providers/lot_provider.dart';
import '../widgets/create_lot_form.dart';
import '../widgets/sensor_card.dart';
import '../widgets/qr_preview.dart';

class CreateLotPage extends StatelessWidget {
  const CreateLotPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LotProvider>(
      builder: (context, provider, child) {
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
                    child: QrPreview(codigoQr: provider.codigoQrGenerado),
                  ),
                ),

                if (provider.codigoQrGenerado != null) ...[
                  const SizedBox(height: 15),

                  FilledButton.icon(
                    onPressed: () {
                      provider.ocultarQr();
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.check_circle),
                    label: const Text("Volver a Lotes"),
                  ),
                ],

                const SizedBox(height: 25),

                FilledButton.icon(
                  onPressed: provider.cargando
                      ? null
                      : () {
                          provider.registrarLote(context);
                        },
                  icon: provider.cargando
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
                    provider.cargando ? "Guardando..." : "Guardar lote",
                  ),
                ),

                const SizedBox(height: 20),

              ],
            ),
          ),
        );
      },
    );
  }
}