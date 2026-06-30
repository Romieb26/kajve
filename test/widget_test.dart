// Basic smoke test for Kajve.
//
// Verifica que la app levanta sin errores.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kajve/main.dart';

void main() {
  testWidgets('App levanta sin errores', (WidgetTester tester) async {
    await tester.pumpWidget(const KajveApp());
    await tester.pump();

    // Si llegamos aquí sin lanzar excepción, la app construyó su árbol
    // de widgets correctamente.
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}