import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Almacenamiento seguro de la sesión (tokens y usuario). No usar
/// SharedPreferences aquí: los tokens deben quedar cifrados en el
/// almacén seguro del sistema operativo.
class SecureStorage {
  SecureStorage({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  static const _keyAccessToken = 'access_token';
  static const _keyRefreshToken = 'refresh_token';
  static const _keyUserId = 'id_usuario';

  Future<void> saveSession({
    required String accessToken,
    required String refreshToken,
    required int idUsuario,
  }) async {
    await _storage.write(key: _keyAccessToken, value: accessToken);
    await _storage.write(key: _keyRefreshToken, value: refreshToken);
    await _storage.write(key: _keyUserId, value: idUsuario.toString());
  }

  Future<void> saveAccessToken(String accessToken) {
    return _storage.write(key: _keyAccessToken, value: accessToken);
  }

  Future<String?> getAccessToken() => _storage.read(key: _keyAccessToken);

  Future<String?> getRefreshToken() => _storage.read(key: _keyRefreshToken);

  Future<int?> getUserId() async {
    final value = await _storage.read(key: _keyUserId);
    return value != null ? int.tryParse(value) : null;
  }

  Future<void> clear() async {
    await _storage.delete(key: _keyAccessToken);
    await _storage.delete(key: _keyRefreshToken);
    await _storage.delete(key: _keyUserId);
  }
}