import 'package:flutter/material.dart';

class QrProvider extends ChangeNotifier {
  /// Estado del flash
  bool flash = false;

  /// Evita múltiples lecturas del mismo QR
  bool procesando = false;

  /// Último código leído
  String? ultimoCodigo;

  /// Activa o desactiva el flash
  void toggleFlash() {
    flash = !flash;
    notifyListeners();
  }

  /// Reinicia el escaneo
  void reiniciarEscaneo() {
    procesando = false;
    ultimoCodigo = null;
    notifyListeners();
  }

  /// Procesa el código QR detectado
  void detectarCodigo(
      BuildContext context,
      String codigo,
      ) {
    if (procesando) return;

    procesando = true;
    ultimoCodigo = codigo;

    notifyListeners();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("QR detectado: $codigo"),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );

    // Aquí más adelante consultaremos la API o Base de Datos
    // para obtener la información del lote usando el código QR.

    /*
    Navigator.pushNamed(
      context,
      AppRoutes.lotDetail,
      arguments: codigo,
    );
    */
  }
}