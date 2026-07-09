import '../entities/perfil_entity.dart';

abstract class ProfileRepository {
  Future<PerfilEntity> getPerfil();

  Future<PerfilEntity> updatePerfil({
    required String nombre,
    required String telefono,
  });

  Future<void> changePassword({
    required String passwordActual,
    required String passwordNueva,
  });
}
