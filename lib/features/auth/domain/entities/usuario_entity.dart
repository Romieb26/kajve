/// Entidad de dominio del usuario autenticado, sin dependencias de Flutter.
class UsuarioEntity {
  final int id;
  final String email;
  final String nombreCompleto;
  final String rol;

  const UsuarioEntity({
    required this.id,
    required this.email,
    required this.nombreCompleto,
    required this.rol,
  });
}