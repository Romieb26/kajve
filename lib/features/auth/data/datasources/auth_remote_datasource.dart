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

    return AuthResponseModel.fromJson(json);
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
