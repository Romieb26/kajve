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
        Text(
          "QR",
          style: Theme.of(context).textTheme.titleLarge,
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
                ? Icon(
                    Icons.qr_code_2,
                    size: 120,
                    color: Colors.grey.shade400,
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
