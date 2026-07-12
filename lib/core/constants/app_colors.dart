import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Café principal
  static const Color primary = Color(0xFF6F4E37);

  // Café claro
  static const Color secondary = Color(0xFFB7791F);

  // Fondo principal
  static const Color background = Color(0xFFF7F3EE);

  // Tarjetas
  static const Color card = Colors.white;

  // Texto principal
  static const Color textPrimary = Color(0xFF2F2F2F);

  // Texto secundario
  static const Color textSecondary = Color(0xFF6B6B6B);

  // Colores de estado
  static const Color success = Color(0xFF2E7D32);
  static const Color warning = Color(0xFFF9A825);
  static const Color error = Color(0xFFC62828);

  // Acento premium (candados, badges y CTA de upgrade). Morado a
  // propósito: no existe en el resto de la paleta café/ámbar, así que
  // resalta como algo distinto a la navegación normal de la app.
  static const Color premium = Color(0xFF8E44AD);
  static const Color premiumBackground = Color(0xFFF3E5F5);

  // Iconos
  static const Color icon = Color(0xFF6F4E37);

  // Bordes
  static const Color border = Color(0xFFE0E0E0);

  // Sombras
  static const Color shadow = Color(0x22000000);

  // ==========================================================
  // Modo oscuro — mismos tonos café/ámbar/naranja de la marca,
  // sobre fondos cálidos oscuros en vez de gris neutro.
  // ==========================================================

  // Fondo principal
  static const Color darkBackground = Color(0xFF1A130D);

  // Tarjetas / superficies
  static const Color darkSurface = Color(0xFF2B2019);

  // AppBar / Drawer / Navigation bar
  static const Color darkAppBar = Color(0xFF241A12);

  // Acento principal (botones, selección, íconos activos)
  static const Color darkAccent = Color(0xFFE3A94E);

  // Texto sobre el acento (para que el botón ámbar no quede
  // con texto blanco de bajo contraste)
  static const Color darkOnAccent = Color(0xFF2A1B08);

  // Bordes / divisores
  static const Color darkBorder = Color(0xFF4C3B2C);

  // Texto principal
  static const Color darkTextPrimary = Color(0xFFF5ECE0);

  // Texto secundario
  static const Color darkTextSecondary = Color(0xFFCBB6A0);
}