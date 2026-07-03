import 'usuario_model.dart';

/// Respuesta de POST /auth/login: tokens de sesión + datos del usuario.
class AuthResponseModel {
  final String accessToken;
  final String refreshToken;
  final int expiresIn;
  final UsuarioModel usuario;

  const AuthResponseModel({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
    required this.usuario,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
      expiresIn: json['expires_in'] as int,
      usuario: UsuarioModel.fromJson(json['usuario'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'expires_in': expiresIn,
      'usuario': usuario.toJson(),
    };
  }
}
