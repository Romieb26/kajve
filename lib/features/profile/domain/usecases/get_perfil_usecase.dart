import 'package:injectable/injectable.dart';

import '../entities/perfil_entity.dart';
import '../repositories/profile_repository.dart';

@injectable
class GetPerfilUseCase {
  final ProfileRepository repository;

  GetPerfilUseCase(this.repository);

  Future<PerfilEntity> call() {
    return repository.getPerfil();
  }
}
