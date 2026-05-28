import '../models/app_user.dart';
import '../services/auth_service.dart';

class AuthController {
  AuthController({AuthService? service}) : _service = service ?? AuthService();

  final AuthService _service;

  Future<void> register({
    required String email,
    required String password,
    required String fullName,
  }) {
    return _service.register(
      email: email,
      password: password,
      fullName: fullName,
    );
  }

  Future<AppUser> login({
    required String email,
    required String password,
  }) {
    return _service.login(email: email, password: password);
  }

  Future<void> sendPasswordResetEmail(String email) {
    return _service.sendPasswordResetEmail(email);
  }
}

