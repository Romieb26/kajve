//lib/shared/widgets/cumstom_dialog.dart
import 'package:flutter/material.dart';

class CustomDialog {
  static Future<void> show({
    required BuildContext context,
    required String title,
    required String content,
    String buttonText = "Aceptar",
  }) async {
    return showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(title),

          content: Text(content),

          actions: [

            FilledButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(buttonText),
            ),

          ],
        );
      },
    );
  }

  static Future<void> confirm({
    required BuildContext context,
    required String title,
    required String content,
    required VoidCallback onConfirm,
    String cancelText = "Cancelar",
    String confirmText = "Confirmar",
  }) async {
    return showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(title),

          content: Text(content),

          actions: [

            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(cancelText),
            ),

            FilledButton(
              onPressed: () {
                Navigator.pop(context);
                onConfirm();
              },
              child: Text(confirmText),
            ),

          ],
        );
      },
    );
  }
}