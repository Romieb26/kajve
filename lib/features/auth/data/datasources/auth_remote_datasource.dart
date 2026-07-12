import 'package:flutter/foundation.dart';

import '../../../../core/network/api_client.dart';
import '../models/auth_response_model.dart';

/// Llamadas HTTP puras a los endpoints de /auth. No maneja estado de UI.
abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  });

  Future<void> register({
    required String nombre,
    required String email,
    required String password,
    required String telefono,
  });

  Future<String> refreshToken(String refreshToken);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSourceImpl(this.apiClient);

  @override
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    final json = await apiClient.post('/auth/login', body: {
      'email': email,
      'password': password,
    });

    try {
      return AuthResponseModel.fromJson(json);
    } catch (e, st) {
      // TODO(debug): quitar una vez identificado el campo que causa el crash.
      debugPrint('LOGIN PARSE ERROR: $e');
      debugPrint('LOGIN RAW JSON: $json');
      debugPrint('$st');
      rethrow;
    }
  }

  @override
  Future<void> register({
    required String nombre,
    required String email,
    required String password,
    required String telefono,
  }) async {
    await apiClient.post('/auth/register', body: {
      'nombre': nombre,
      'email': email,
      'password': password,
      'telefono': telefono,
    });
  }

  @override
  Future<String> refreshToken(String refreshToken) async {
    final json = await apiClient.post('/auth/refresh', body: {
      'refresh_token': refreshToken,
    });

    return json['access_token'] as String;
  }
}
