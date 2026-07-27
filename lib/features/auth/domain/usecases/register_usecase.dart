import 'package:injectable/injectable.dart';

import '../repositories/auth_repository.dart';

@injectable
class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<void> call({
    required String nombre,
    required String email,
    required String password,
    required String telefono,
  }) {
    return repository.register(
      nombre: nombre,
      email: email,
      password: password,
      telefono: telefono,
    );
  }
}