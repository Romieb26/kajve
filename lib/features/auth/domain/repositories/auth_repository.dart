import '../entities/usuario_entity.dart';

/// Resultado de un login exitoso: tokens de sesión y datos del usuario.
class AuthSession {
  final String accessToken;
  final String refreshToken;
  final int expiresIn;
  final UsuarioEntity usuario;

  const AuthSession({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
    required this.usuario,
  });
}

abstract class AuthRepository {
  Future<AuthSession> login({
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

  Future<void> logout();
}