import '../entities/perfil_entity.dart';
import '../repositories/profile_repository.dart';

class UpdatePerfilUseCase {
  final ProfileRepository repository;

  UpdatePerfilUseCase(this.repository);

  Future<PerfilEntity> call({
    required String nombre,
    required String telefono,
  }) {
    return repository.updatePerfil(nombre: nombre, telefono: telefono);
  }
}
