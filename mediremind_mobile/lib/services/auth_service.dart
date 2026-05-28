import '../data/repositories/auth_repository.dart';
import '../models/app_user.dart';

class AuthService {
  AuthService({AuthRepository? repository})
    : _repository = repository ?? AuthRepository();

  final AuthRepository _repository;

  Future<void> register({
    required String email,
    required String password,
    required String fullName,
  }) {
    return _repository.register(
      email: email.trim(),
      password: password,
      fullName: fullName.trim(),
    );
  }

  Future<AppUser> login({
    required String email,
    required String password,
  }) {
    return _repository.login(email: email.trim(), password: password);
  }

  Future<void> sendPasswordResetEmail(String email) {
    return _repository.sendPasswordResetEmail(email.trim());
  }

  Future<void> logout() {
    return _repository.logout();
  }
}

