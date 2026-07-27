import 'package:injectable/injectable.dart';

import '../repositories/auth_repository.dart';

@injectable
class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<AuthSession> call({
    required String email,
    required String password,
  }) {
    return repository.login(email: email, password: password);
  }
}