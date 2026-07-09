import '../repositories/profile_repository.dart';

class ChangePasswordUseCase {
  final ProfileRepository repository;

  ChangePasswordUseCase(this.repository);

  Future<void> call({
    required String passwordActual,
    required String passwordNueva,
  }) {
    return repository.changePassword(
      passwordActual: passwordActual,
      passwordNueva: passwordNueva,
    );
  }
}
