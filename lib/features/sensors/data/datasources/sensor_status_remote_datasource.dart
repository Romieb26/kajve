//libs/features/sensors/data/datasources/sensor_status_remote_datasource.dart
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/network/api_client.dart';
import '../../../../core/storage/secure_storage.dart';
import '../models/estado_sensor_model.dart';
import '../models/sensor_model.dart';

/// Llama a `GET /sensores/estado`, que vive en ws-gateway (NO en
/// api-mobile) — por eso no usa el ApiClient normal, que apunta al
/// dominio del gateway de api-mobile.
class SensorStatusRemoteDataSource {
  // Mismo host que RealtimeWsDataSource (features/realtime): ws-gateway
  // desplegado en el servidor, detrás de TLS.
  static const String _host = 'ws.dnc-ed-denz.shop';
  static const bool _useTls = true;

  final http.Client _client;
  final SecureStorage _secureStorage;

  SensorStatusRemoteDataSource({
    http.Client? client,
    SecureStorage? secureStorage,
  })  : _client = client ?? http.Client(),
        _secureStorage = secureStorage ?? SecureStorage();

  Future<List<SensorModel>> getEstadoSensores() async {
    final token = await _secureStorage.getAccessToken();
    if (token == null) {
      throw const ApiException(
        'Sesión expirada. Inicia sesión de nuevo.',
        statusCode: 401,
      );
    }

    final scheme = _useTls ? 'https' : 'http';
    final uri = Uri.parse('$scheme://$_host/sensores/estado');

    http.Response response;
    try {
      response = await _client
          .get(uri, headers: {'Authorization': 'Bearer $token'})
          .timeout(const Duration(seconds: 10));
    } catch (_) {
      throw const ApiException(
        'No se pudo conectar con el servidor de sensores.',
      );
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(
        'Error consultando el estado de los sensores.',
        statusCode: response.statusCode,
      );
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final lista = body['sensores'] as List<dynamic>? ?? [];

    return lista
        .map((e) => EstadoSensorModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
