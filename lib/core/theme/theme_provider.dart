//lib/core/theme/theme_provider.dart
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_provider.g.dart';

/// Controla el modo de tema (claro/oscuro) elegido manualmente por el
/// usuario en el perfil, persistido en el dispositivo. No sigue el
/// tema del sistema operativo.
@riverpod
class ThemeModeController extends _$ThemeModeController {
  static const _prefsKey = 'modo_oscuro';

  bool get modoOscuro => state == ThemeMode.dark;

  @override
  ThemeMode build() {
    _cargarPreferencia();
    return ThemeMode.light;
  }

  Future<void> _cargarPreferencia() async {
    final prefs = await SharedPreferences.getInstance();
    final modoOscuro = prefs.getBool(_prefsKey) ?? false;
    state = modoOscuro ? ThemeMode.dark : ThemeMode.light;
  }

  Future<void> cambiarTema(bool activarOscuro) async {
    state = activarOscuro ? ThemeMode.dark : ThemeMode.light;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefsKey, activarOscuro);
  }
}
