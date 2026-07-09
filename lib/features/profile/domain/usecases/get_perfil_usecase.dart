import '../entities/perfil_entity.dart';
import '../repositories/profile_repository.dart';

class GetPerfilUseCase {
  final ProfileRepository repository;

  GetPerfilUseCase(this.repository);

  Future<PerfilEntity> call() {
    return repository.getPerfil();
  }
}
