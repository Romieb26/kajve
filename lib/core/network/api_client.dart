import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

/// Excepción centralizada para errores de red y de la API.
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  const ApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

/// Respuesta binaria (ej. descarga de un reporte en PDF/Excel).
class ApiFileResponse {
  final List<int> bytes;
  final String? contentType;
  final String? fileName;

  const ApiFileResponse({required this.bytes, this.contentType, this.fileName});
}

/// Wrapper de [http] con timeout y manejo de errores centralizado.
class ApiClient {
  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  // URL vieja (llamada directa a api-mobile, sin gateway). Para revertir en
  // caso de falla del gateway el día de la demo: comentar la línea de abajo
  // y descomentar esta.
  // static const String baseUrl = 'https://api-mobile.dnc-ed-denz.shop';
  static const String baseUrl = 'https://gateway.dnc-ed-denz.shop/mobile';
  static const Duration _timeout = Duration(seconds: 10);

  final http.Client _client;

  Future<Map<String, dynamic>> get(String path, {String? token}) async {
    final result = await _send(
      () => _client
          .get(Uri.parse('$baseUrl$path'), headers: _headers(token))
          .timeout(_timeout),
    );
    return (result as Map<String, dynamic>?) ?? <String, dynamic>{};
  }

  /// Igual que [get], pero para endpoints cuya respuesta es un array
  /// JSON en la raíz (ej. GET /lotes/{id}/lecturas) en vez de un objeto.
  Future<List<dynamic>> getList(String path, {String? token}) async {
    final result = await _send(
      () => _client
          .get(Uri.parse('$baseUrl$path'), headers: _headers(token))
          .timeout(_timeout),
    );
    return (result as List<dynamic>?) ?? <dynamic>[];
  }

  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? body,
    String? token,
  }) async {
    final result = await _send(
      () => _client
          .post(
            Uri.parse('$baseUrl$path'),
            headers: _headers(token),
            body: jsonEncode(body ?? {}),
          )
          .timeout(_timeout),
    );
    return (result as Map<String, dynamic>?) ?? <String, dynamic>{};
  }

  Future<Map<String, dynamic>> put(
    String path, {
    Map<String, dynamic>? body,
    String? token,
  }) async {
    final result = await _send(
      () => _client
          .put(
            Uri.parse('$baseUrl$path'),
            headers: _headers(token),
            body: jsonEncode(body ?? {}),
          )
          .timeout(_timeout),
    );
    return (result as Map<String, dynamic>?) ?? <String, dynamic>{};
  }

  /// Descarga el binario de un endpoint (ej. GET /reportes/{id}/descargar).
  /// A diferencia de [get]/[post], el cuerpo de una respuesta exitosa no se
  /// intenta decodificar como JSON.
  Future<ApiFileResponse> getBytes(String path, {String? token}) async {
    try {
      final response = await _client
          .get(Uri.parse('$baseUrl$path'), headers: _headers(token))
          .timeout(_timeout);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return ApiFileResponse(
          bytes: response.bodyBytes,
          contentType: response.headers['content-type'],
          fileName: _parseFileName(response.headers['content-disposition']),
        );
      }

      throw _errorFromResponse(response);
    } on ApiException {
      rethrow;
    } on TimeoutException {
      throw const ApiException(
        'La conexión tardó demasiado. Intenta de nuevo.',
      );
    } on SocketException {
      throw const ApiException(
        'No se pudo conectar. Revisa tu conexión a internet.',
      );
    } catch (_) {
      throw const ApiException('Ocurrió un error inesperado.');
    }
  }

  String? _parseFileName(String? contentDisposition) {
    if (contentDisposition == null) return null;
    final match = RegExp(r'filename="?([^";]+)"?').firstMatch(contentDisposition);
    return match?.group(1);
  }

  Map<String, String> _headers(String? token) {
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<dynamic> _send(
    Future<http.Response> Function() request,
  ) async {
    try {
      final response = await request();
      return _handleResponse(response);
    } on ApiException {
      rethrow;
    } on TimeoutException {
      throw const ApiException(
        'La conexión tardó demasiado. Intenta de nuevo.',
      );
    } on SocketException {
      throw const ApiException(
        'No se pudo conectar. Revisa tu conexión a internet.',
      );
    } catch (_) {
      throw const ApiException('Ocurrió un error inesperado.');
    }
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response.body.isNotEmpty ? jsonDecode(response.body) : null;
    }

    throw _errorFromResponse(response);
  }

  ApiException _errorFromResponse(http.Response response) {
    Map<String, dynamic> json = {};
    try {
      final decoded = response.body.isNotEmpty ? jsonDecode(response.body) : null;
      if (decoded is Map<String, dynamic>) json = decoded;
    } catch (_) {}

    return ApiException(
      json['message']?.toString() ??
          json['error']?.toString() ??
          'Error en la solicitud.',
      statusCode: response.statusCode,
    );
  }
}