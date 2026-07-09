import '../../domain/entities/perfil_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl(this.remoteDataSource);

  @override
  Future<PerfilEntity> getPerfil() {
    return remoteDataSource.getPerfil();
  }

  @override
  Future<PerfilEntity> updatePerfil({
    required String nombre,
    required String telefono,
  }) {
    return remoteDataSource.updatePerfil(nombre: nombre, telefono: telefono);
  }

  @override
  Future<void> changePassword({
    required String passwordActual,
    required String passwordNueva,
  }) {
    return remoteDataSource.changePassword(
      passwordActual: passwordActual,
      passwordNueva: passwordNueva,
    );
  }
}
