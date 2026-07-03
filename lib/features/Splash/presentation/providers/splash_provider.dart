import 'package:flutter/material.dart';

import '../../../../core/routes/app_routes.dart';

class SplashProvider extends ChangeNotifier {

  Future<void> iniciar(BuildContext context) async {

    await Future.delayed(const Duration(seconds: 3));

    if (!context.mounted) return;

    Navigator.pushReplacementNamed(
      context,
      AppRoutes.login,
    );
  }
}