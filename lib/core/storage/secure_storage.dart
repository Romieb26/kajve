/// Almacenamiento de la sesión (tokens y usuario) SOLO EN MEMORIA.
///
/// Los tokens nunca se escriben a disco: se guardan en campos estáticos
/// que viven mientras el proceso de la app esté vivo (incluido segundo
/// plano). Si el usuario mata la app, el proceso termina y este estado
/// se pierde, por lo que al volver a abrirla debe iniciar sesión de
/// nuevo. Esto es intencional (requisito de seguridad), no un bug.
class SecureStorage {
  static String? _accessToken;
  static String? _refreshToken;
  static int? _userId;

  Future<void> saveSession({
    required String accessToken,
    required String refreshToken,
    required int idUsuario,
  }) async {
    _accessToken = accessToken;
    _refreshToken = refreshToken;
    _userId = idUsuario;
  }

  Future<void> saveAccessToken(String accessToken) async {
    _accessToken = accessToken;
  }

  Future<String?> getAccessToken() async => _accessToken;

  Future<String?> getRefreshToken() async => _refreshToken;

  Future<int?> getUserId() async => _userId;

  Future<void> clear() async {
    _accessToken = null;
    _refreshToken = null;
    _userId = null;
  }
}
