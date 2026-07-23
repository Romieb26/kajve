//lib/features/devices/data/datasources/devices_remote_datasource.dart
import '../../../../core/network/api_client.dart';
import '../../../../core/storage/secure_storage.dart';

abstract class DevicesRemoteDataSource {
  Future<void> registrarDispositivo(String fcmToken);
  Future<void> desactivarDispositivo(String fcmToken);
}

class DevicesRemoteDataSourceImpl implements DevicesRemoteDataSource {
  final ApiClient apiClient;
  final SecureStorage secureStorage;

  DevicesRemoteDataSourceImpl(this.apiClient, this.secureStorage);

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
  Future<void> registrarDispositivo(String fcmToken) async {
    final token = await _requireToken();

    await apiClient.post(
      '/dispositivos/registrar',
      baseUrlOverride: ApiClient.mlBaseUrl,
      body: {'fcm_token': fcmToken, 'plataforma': 'android'},
      token: token,
    );
  }

  @override
  Future<void> desactivarDispositivo(String fcmToken) async {
    final token = await _requireToken();

    await apiClient.post(
      '/dispositivos/desactivar',
      baseUrlOverride: ApiClient.apiV1BaseUrl,
      body: {'fcm_token': fcmToken},
      token: token,
    );
  }
}
