//lib/core/storage/theme_provider.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Controla el modo de tema (claro/oscuro) elegido manualmente por el
/// usuario en el perfil, persistido en el dispositivo. No sigue el
/// tema del sistema operativo.
class ThemeProvider extends ChangeNotifier {
  static const _prefsKey = 'modo_oscuro';

  bool _modoOscuro = false;

  bool get modoOscuro => _modoOscuro;

  ThemeMode get themeMode => _modoOscuro ? ThemeMode.dark : ThemeMode.light;

  ThemeProvider() {
    _cargarPreferencia();
  }

  Future<void> _cargarPreferencia() async {
    final prefs = await SharedPreferences.getInstance();
    _modoOscuro = prefs.getBool(_prefsKey) ?? false;
    notifyListeners();
  }

  Future<void> cambiarTema(bool activarOscuro) async {
    _modoOscuro = activarOscuro;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefsKey, activarOscuro);
  }
}
