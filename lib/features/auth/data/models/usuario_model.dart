import '../../domain/entities/usuario_entity.dart';

class UsuarioModel extends UsuarioEntity {
  const UsuarioModel({
    required super.id,
    required super.email,
    required super.nombreCompleto,
    required super.rol,
  });

  factory UsuarioModel.fromJson(Map<String, dynamic> json) {
    return UsuarioModel(
      id: json['id'] as int,
      email: json['email'] as String,
      nombreCompleto: json['nombre_completo'] as String,
      rol: json['rol'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'nombre_completo': nombreCompleto,
      'rol': rol,
    };
  }
}
