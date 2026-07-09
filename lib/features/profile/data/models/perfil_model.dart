import '../../domain/entities/perfil_entity.dart';

class PerfilModel extends PerfilEntity {
  const PerfilModel({
    required super.idUsuario,
    required super.nombre,
    required super.email,
    required super.rol,
    super.telefono,
    required super.estado,
    required super.fechaRegistro,
  });

  factory PerfilModel.fromJson(Map<String, dynamic> json) {
    return PerfilModel(
      idUsuario: json['id_usuario'] as int,
      nombre: json['nombre'] as String? ?? '',
      email: json['email'] as String? ?? '',
      rol: json['rol'] as String? ?? '',
      telefono: json['telefono'] as String?,
      estado: json['estado'] as String? ?? '',
      fechaRegistro: json['fecha_registro'] as String? ?? '',
    );
  }
}
