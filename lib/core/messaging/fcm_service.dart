//lib/core/messaging/fcm_service.dart
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import '../network/api_client.dart';
import '../storage/secure_storage.dart';
import '../../features/devices/data/datasources/devices_remote_datasource.dart';

/// Handler de background: debe ser función top-level (fuera de cualquier
/// clase) y marcada con @pragma('vm:entry-point') porque el SDK la invoca
/// desde un isolate separado cuando la app está en segundo plano o cerrada.
/// Por ahora solo loguea — sin lógica de negocio todavía.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('FCM background message: ${message.messageId}');
}

class FcmService {
  // Compartido entre instancias (mismo patrón que SecureStorage): main.dart
  // crea un FcmService antes de cualquier login, AuthProvider crea otro al
  // loguear — ambos deben ver el mismo token pendiente.
  static String? _pendingToken;

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final SecureStorage _secureStorage = SecureStorage();
  final DevicesRemoteDataSource _devicesRemoteDataSource =
      DevicesRemoteDataSourceImpl(ApiClient(), SecureStorage());

  Future<String?> inicializar() async {
    final settings = await _messaging.requestPermission();
    debugPrint('FCM permiso: ${settings.authorizationStatus}');

    final token = await _messaging.getToken();
    debugPrint('FCM token: $token');

    if (token != null) {
      await _registrarOGuardarPendiente(token);
    }

    _messaging.onTokenRefresh.listen((nuevoToken) {
      debugPrint('FCM token renovado: $nuevoToken');
      _registrarOGuardarPendiente(nuevoToken);
    });

    FirebaseMessaging.onMessage.listen((message) {
      debugPrint(
        'FCM mensaje en foreground: ${message.notification?.title} - ${message.notification?.body}',
      );
    });

    return token;
  }

  Future<void> _registrarOGuardarPendiente(String token) async {
    final haySesion = await _secureStorage.getAccessToken() != null;

    if (!haySesion) {
      _pendingToken = token;
      return;
    }

    await _registrar(token);
  }

  /// Se llama justo después de un login exitoso (ver AuthProvider), para
  /// registrar el token FCM que ya se haya obtenido/renovado mientras
  /// todavía no había sesión activa.
  Future<void> registrarTokenPendienteSiExiste() async {
    final token = _pendingToken;
    if (token == null) return;

    await _registrar(token);
  }

  Future<void> _registrar(String token) async {
    try {
      await _devicesRemoteDataSource.registrarDispositivo(token);
      _pendingToken = null;
      debugPrint('FCM token registrado en backend.');
    } catch (e) {
      // No relanzamos: un fallo al registrar el dispositivo no debe
      // romper el login ni el arranque de la app.
      debugPrint('FCM: fallo al registrar token en backend: $e');
    }
  }
}
