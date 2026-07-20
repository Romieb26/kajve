//lib/features/monitoring/data/datasources/resumen_lote_remote_datasource.dart
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/network/api_client.dart';
import '../../../../core/storage/secure_storage.dart';
import '../models/resumen_lote_model.dart';

/// Llama a `GET /lotes/{id}/resumen`, que vive en ws-gateway (NO en
/// api-mobile) — igual que SensorStatusRemoteDataSource, por eso no usa el
/// ApiClient normal, que apunta al dominio del gateway de api-mobile.
class ResumenLoteRemoteDataSource {
  // TODO: mismo host/puerto que RealtimeWsDataSource/SensorStatusRemote-
  // DataSource. Mientras ws-gateway no esté desplegado detrás de un
  // dominio público, apunta esto a la IP local de la PC donde corre
  // `go run .` — el celular debe estar en la misma red Wi-Fi que la PC.
  static const String _host = '192.168.1.90';
  static const int _port = 8002;
  static const bool _useTls = false;

  final http.Client _client;
  final SecureStorage _secureStorage;

  ResumenLoteRemoteDataSource({
    http.Client? client,
    SecureStorage? secureStorage,
  })  : _client = client ?? http.Client(),
        _secureStorage = secureStorage ?? SecureStorage();

  Future<ResumenLoteModel> getResumen(int loteId) async {
    final token = await _secureStorage.getAccessToken();
    if (token == null) {
      throw const ApiException(
        'Sesión expirada. Inicia sesión de nuevo.',
        statusCode: 401,
      );
    }

    final scheme = _useTls ? 'https' : 'http';
    final uri = Uri.parse('$scheme://$_host:$_port/lotes/$loteId/resumen');

    http.Response response;
    try {
      response = await _client
          .get(uri, headers: {'Authorization': 'Bearer $token'})
          .timeout(const Duration(seconds: 10));
    } catch (_) {
      throw const ApiException(
        'No se pudo conectar con el servidor de resumen.',
      );
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(
        'Error consultando el resumen del lote.',
        statusCode: response.statusCode,
      );
    }

    return ResumenLoteModel.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }
}
