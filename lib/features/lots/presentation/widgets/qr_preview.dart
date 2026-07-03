import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrPreview extends StatelessWidget {
  /// Código real devuelto por el backend tras crear el lote. Mientras
  /// sea null (aún no se ha guardado el lote) se muestra un placeholder.
  final String? codigoQr;

  const QrPreview({super.key, this.codigoQr});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "QR",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 10),

        Container(
          width: 180,
          height: 180,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Center(
            child: codigoQr == null
                ? const Icon(
                    Icons.qr_code_2,
                    size: 120,
                  )
                : QrImageView(
                    data: codigoQr!,
                    size: 150,
                    padding: const EdgeInsets.all(8),
                  ),
          ),
        ),
      ],
    );
  }
}
