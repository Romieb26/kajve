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
  // Mismo host que RealtimeWsDataSource/SensorStatusRemoteDataSource:
  // ws-gateway desplegado en el servidor, detrás de TLS.
  static const String _host = 'ws.dnc-ed-denz.shop';
  static const bool _useTls = true;

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
    final uri = Uri.parse('$scheme://$_host/lotes/$loteId/resumen');

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
