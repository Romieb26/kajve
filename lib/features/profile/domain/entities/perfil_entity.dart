class PerfilEntity {
  final int idUsuario;
  final String nombre;
  final String email;
  final String rol;
  final String? telefono;
  final String estado;
  final String fechaRegistro;

  const PerfilEntity({
    required this.idUsuario,
    required this.nombre,
    required this.email,
    required this.rol,
    this.telefono,
    required this.estado,
    required this.fechaRegistro,
  });
}
