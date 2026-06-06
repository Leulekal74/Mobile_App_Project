import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/features/auth/application/auth_controller.dart';
import 'package:frontend/features/auth/domain/entities/app_user.dart';
import 'package:frontend/features/auth/domain/entities/auth_session.dart';
import 'package:frontend/features/auth/domain/repositories/auth_repository.dart';

void main() {
  test('AuthController restores, logs in, and logs out a session', () async {
    final repository = _FakeAuthRepository();
    final container = ProviderContainer(
      overrides: [authRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);

    expect(await container.read(authControllerProvider.future), isNull);

    await container
        .read(authControllerProvider.notifier)
        .login(email: 'seller@example.com', password: 'secret');

    final loggedInSession = container.read(authControllerProvider).value;
    expect(loggedInSession?.token, 'test-token');
    expect(loggedInSession?.user.role, UserRole.seller);
    expect(repository.loginEmail, 'seller@example.com');

    await container.read(authControllerProvider.notifier).logout();

    expect(container.read(authControllerProvider).value, isNull);
    expect(repository.logoutCalled, isTrue);
  });
}

class _FakeAuthRepository implements AuthRepository {
  String? loginEmail;
  bool logoutCalled = false;

  @override
  Future<AuthSession?> restoreSession() async => null;

  @override
  Future<AuthSession> login({
    required String email,
    required String password,
  }) async {
    loginEmail = email;
    return const AuthSession(
      token: 'test-token',
      user: AppUser(
        id: 'user-1',
        name: 'Test Seller',
        email: 'seller@example.com',
        role: UserRole.seller,
      ),
    );
  }

  @override
  Future<AuthSession> signup({
    required String name,
    required String email,
    required String password,
    required UserRole role,
  }) async {
    return AuthSession(
      token: 'signup-token',
      user: AppUser(id: 'user-2', name: name, email: email, role: role),
    );
  }

  @override
  Future<void> logout() async {
    logoutCalled = true;
  }
}
