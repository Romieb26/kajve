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

/// Wrapper de [http] con timeout y manejo de errores centralizado.
class ApiClient {
  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  static const String baseUrl = 'https://api-mobile.dnc-ed-denz.shop';
  static const Duration _timeout = Duration(seconds: 10);

  final http.Client _client;

  Future<Map<String, dynamic>> get(String path, {String? token}) {
    return _send(
      () => _client
          .get(Uri.parse('$baseUrl$path'), headers: _headers(token))
          .timeout(_timeout),
    );
  }

  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? body,
    String? token,
  }) {
    return _send(
      () => _client
          .post(
            Uri.parse('$baseUrl$path'),
            headers: _headers(token),
            body: jsonEncode(body ?? {}),
          )
          .timeout(_timeout),
    );
  }

  Map<String, String> _headers(String? token) {
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<Map<String, dynamic>> _send(
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

  Map<String, dynamic> _handleResponse(http.Response response) {
    final decoded = response.body.isNotEmpty ? jsonDecode(response.body) : {};
    final json = decoded is Map<String, dynamic> ? decoded : <String, dynamic>{};

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json;
    }

    throw ApiException(
      json['message']?.toString() ??
          json['error']?.toString() ??
          'Error en la solicitud.',
      statusCode: response.statusCode,
    );
  }
}