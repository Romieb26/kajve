import '../../../../core/storage/secure_storage.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final SecureStorage secureStorage;

  AuthRepositoryImpl(this.remoteDataSource, this.secureStorage);

  @override
  Future<AuthSession> login({
    required String email,
    required String password,
  }) async {
    final response = await remoteDataSource.login(
      email: email,
      password: password,
    );

    return AuthSession(
      accessToken: response.accessToken,
      refreshToken: response.refreshToken,
      expiresIn: response.expiresIn,
      usuario: response.usuario,
    );
  }

  @override
  Future<void> register({
    required String nombre,
    required String email,
    required String password,
    required String telefono,
  }) {
    return remoteDataSource.register(
      nombre: nombre,
      email: email,
      password: password,
      telefono: telefono,
    );
  }

  @override
  Future<String> refreshToken(String refreshToken) {
    return remoteDataSource.refreshToken(refreshToken);
  }

  @override
  Future<void> logout() {
    // No existe endpoint de logout en la API: la sesión se cierra
    // localmente eliminando los tokens del almacenamiento seguro.
    return secureStorage.clear();
  }
}
