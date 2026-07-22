//lib/core/messaging/fcm_service.dart
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

/// Handler de background: debe ser función top-level (fuera de cualquier
/// clase) y marcada con @pragma('vm:entry-point') porque el SDK la invoca
/// desde un isolate separado cuando la app está en segundo plano o cerrada.
/// Por ahora solo loguea — sin lógica de negocio todavía.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('FCM background message: ${message.messageId}');
}

class FcmService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<String?> inicializar() async {
    final settings = await _messaging.requestPermission();
    debugPrint('FCM permiso: ${settings.authorizationStatus}');

    final token = await _messaging.getToken();
    debugPrint('FCM token: $token');

    _messaging.onTokenRefresh.listen((nuevoToken) {
      debugPrint('FCM token renovado: $nuevoToken');
    });

    FirebaseMessaging.onMessage.listen((message) {
      debugPrint(
        'FCM mensaje en foreground: ${message.notification?.title} - ${message.notification?.body}',
      );
    });

    return token;
  }
}
