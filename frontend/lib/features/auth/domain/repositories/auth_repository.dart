import '../entities/auth_session.dart';
import '../entities/app_user.dart';

abstract class AuthRepository {
  Future<AuthSession?> restoreSession();
  Future<AuthSession> login({
    required String email,
    required String password,
  });
  Future<AuthSession> signup({
    required String name,
    required String email,
    required String password,
    required UserRole role,
  });
  Future<void> logout();
}
