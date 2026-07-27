import 'package:injectable/injectable.dart';

import '../repositories/auth_repository.dart';

@injectable
class RefreshTokenUseCase {
  final AuthRepository repository;

  RefreshTokenUseCase(this.repository);

  Future<String> call(String refreshToken) {
    return repository.refreshToken(refreshToken);
  }
}