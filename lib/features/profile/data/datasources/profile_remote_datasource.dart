import '../../../../core/network/api_client.dart';
import '../../../../core/storage/secure_storage.dart';
import '../models/perfil_model.dart';

/// Llamadas HTTP puras a /perfil. No maneja estado de UI.
abstract class ProfileRemoteDataSource {
  Future<PerfilModel> getPerfil();

  /// El backend no soporta actualización parcial: nombre y telefono
  /// van siempre juntos. El email no se puede cambiar desde aquí.
  Future<PerfilModel> updatePerfil({
    required String nombre,
    required String telefono,
  });

  Future<void> changePassword({
    required String passwordActual,
    required String passwordNueva,
  });
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final ApiClient apiClient;
  final SecureStorage secureStorage;

  ProfileRemoteDataSourceImpl(this.apiClient, this.secureStorage);

  Future<String> _requireToken() async {
    final token = await secureStorage.getAccessToken();

    if (token == null) {
      throw const ApiException(
        'Sesión expirada. Inicia sesión de nuevo.',
        statusCode: 401,
      );
    }

    return token;
  }

  @override
  Future<PerfilModel> getPerfil() async {
    final token = await _requireToken();

    final response = await apiClient.get('/perfil', token: token);

    return PerfilModel.fromJson(response);
  }

  @override
  Future<PerfilModel> updatePerfil({
    required String nombre,
    required String telefono,
  }) async {
    final token = await _requireToken();

    final response = await apiClient.put(
      '/perfil',
      body: {
        'nombre': nombre,
        'telefono': telefono,
      },
      token: token,
    );

    return PerfilModel.fromJson(response);
  }

  @override
  Future<void> changePassword({
    required String passwordActual,
    required String passwordNueva,
  }) async {
    final token = await _requireToken();

    await apiClient.put(
      '/perfil/password',
      body: {
        'password_actual': passwordActual,
        'password_nueva': passwordNueva,
      },
      token: token,
    );
  }
}
