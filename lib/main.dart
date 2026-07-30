//main.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'core/di/injection.dart';
import 'core/messaging/fcm_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }
  await configureDependencies();
  if (!kIsWeb) {
    await getIt<FcmService>().inicializar();
  }
  runApp(
    // DevicePreview solo se activa fuera de modo Release (!kReleaseMode):
    // es una herramienta de desarrollo para probar distintos tamaños de
    // pantalla desde un solo emulador, no algo que deba llegar a producción.
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const ProviderScope(child: KajveApp()),
    ),
  );
}
