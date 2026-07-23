//lib/core/messaging/fcm_service.dart
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import '../network/api_client.dart';
import '../storage/secure_storage.dart';
import '../navigation/navigator_key.dart';
import '../routes/app_routes.dart';
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
  static int? _pendingLoteIdAlertas;

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

    FirebaseMessaging.onMessageOpenedApp.listen(_manejarAperturaNotificacion);

    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      await _manejarAperturaNotificacion(initialMessage);
    }

    return token;
  }

  /// Extrae id_lote del payload data de la notificación y navega a
  /// Alertas de ese lote. Si no hay sesión activa todavía (caso
  /// getInitialMessage: la app estaba cerrada del todo, así que la
  /// sesión en memoria se perdió con el proceso anterior) o el
  /// Navigator todavía no existe, guarda el loteId pendiente para que
  /// SplashProvider/AuthProvider lo consuman apenas haya sesión.
  Future<void> _manejarAperturaNotificacion(RemoteMessage message) async {
    final loteId = int.tryParse(message.data['id_lote']?.toString() ?? '');
    if (loteId == null) return;

    final haySesion = await _secureStorage.getAccessToken() != null;
    final navigatorState = navigatorKey.currentState;

    if (haySesion && navigatorState != null) {
      navigatorState.pushNamed(AppRoutes.alerts, arguments: loteId);
      return;
    }

    _pendingLoteIdAlertas = loteId;
  }

  /// Se llama después de que ya hay sesión activa (login exitoso o
  /// sesión reanudada en Splash) para navegar a Alertas del lote que
  /// venía pendiente de una notificación tocada antes de loguearse.
  int? consumirLotePendienteAlertas() {
    final loteId = _pendingLoteIdAlertas;
    _pendingLoteIdAlertas = null;
    return loteId;
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

  /// Token FCM actual, para desactivarlo al cerrar sesión. Volver a
  /// pedirlo es idempotente (no genera uno nuevo).
  Future<String?> obtenerTokenActual() => _messaging.getToken();

  /// Se llama al cerrar sesión, antes de limpiar la sesión local, para
  /// que el backend deje de mandar push a este dispositivo. Un fallo
  /// acá no debe bloquear el logout.
  Future<void> desactivarDispositivoActual() async {
    try {
      final token = await obtenerTokenActual();
      if (token == null) return;

      await _devicesRemoteDataSource.desactivarDispositivo(token);
      debugPrint('FCM token desactivado en backend.');
    } catch (e) {
      debugPrint('FCM: fallo al desactivar token en backend: $e');
    }
  }
}
