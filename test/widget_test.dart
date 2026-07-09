// Smoke test acotado: no pump-ea KajveApp completo porque el arranque
// real (SplashProvider) dispara secure storage + una llamada de red real
// sin ningún punto de inyección para sustituirlos en tests hoy. En vez de
// eso, se verifica que el theme y el mapa de rutas —lo único aquí sin
// dependencias externas— estén correctamente armados.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kajve/core/routes/app_pages.dart';
import 'package:kajve/core/routes/app_routes.dart';
import 'package:kajve/core/theme/app_theme.dart';

void main() {
  test('AppTheme.light y AppTheme.dark se construyen sin errores', () {
    expect(AppTheme.light, isA<ThemeData>());
    expect(AppTheme.dark, isA<ThemeData>());
  });

  test('AppPages.routes registra las rutas principales de la app', () {
    const rutasEsperadas = [
      AppRoutes.splash,
      AppRoutes.login,
      AppRoutes.register,
      AppRoutes.dashboard,
      AppRoutes.lots,
      AppRoutes.createLot,
      AppRoutes.lotDetail,
      AppRoutes.qr,
      AppRoutes.prediction,
      AppRoutes.realtime,
      AppRoutes.history,
      AppRoutes.alerts,
      AppRoutes.reports,
      AppRoutes.profile,
      AppRoutes.sensors,
      AppRoutes.createSensor,
    ];

    for (final ruta in rutasEsperadas) {
      expect(
        AppPages.routes.containsKey(ruta),
        isTrue,
        reason: 'Falta registrar la ruta "$ruta" en AppPages.routes',
      );
    }
  });
}
