import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AuthRole { customer, artisan }

class AuthSessionState {
  final String email;
  final String password;
  final AuthRole role;
  final bool isLoading;
  final bool isAuthenticated;
  final String? errorMessage;
  final String? infoMessage;

  const AuthSessionState({
    this.email = '',
    this.password = '',
    this.role = AuthRole.customer,
    this.isLoading = false,
    this.isAuthenticated = false,
    this.errorMessage,
    this.infoMessage,
  });

  AuthSessionState copyWith({
    String? email,
    String? password,
    AuthRole? role,
    bool? isLoading,
    bool? isAuthenticated,
    String? errorMessage,
    String? infoMessage,
  }) {
    return AuthSessionState(
      email: email ?? this.email,
      password: password ?? this.password,
      role: role ?? this.role,
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      errorMessage: errorMessage,
      infoMessage: infoMessage,
    );
  }
}

class AuthSessionNotifier extends StateNotifier<AuthSessionState> {
  AuthSessionNotifier() : super(const AuthSessionState());

  static const _mockEmail = 'test@example.com';
  static const _mockPassword = '123456';

  void setEmail(String email) {
    state = state.copyWith(email: email.trim(), errorMessage: null, infoMessage: null);
  }

  void setPassword(String password) {
    state = state.copyWith(password: password, errorMessage: null, infoMessage: null);
  }

  void setRole(AuthRole role) {
    state = state.copyWith(role: role, errorMessage: null, infoMessage: null);
  }

  void clearMessages() {
    state = state.copyWith(errorMessage: null, infoMessage: null);
  }

  Future<bool> login() async {
    state = state.copyWith(isLoading: true, errorMessage: null, infoMessage: null);
    await Future.delayed(const Duration(milliseconds: 600));

    final isValidCredentials = state.email == _mockEmail && state.password == _mockPassword;

    if (!isValidCredentials) {
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: false,
        errorMessage: 'Invalid email or password. Use test@example.com / 123456.',
      );
      return false;
    }

    state = state.copyWith(
      isLoading: false,
      isAuthenticated: true,
      errorMessage: null,
      infoMessage: 'Login successful. Welcome back!',
    );
    return true;
  }

  Future<bool> signup() async {
    state = state.copyWith(isLoading: true, errorMessage: null, infoMessage: null);
    await Future.delayed(const Duration(milliseconds: 700));

    if (state.email.isEmpty || !state.email.contains('@')) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Please enter a valid email address.',
      );
      return false;
    }

    if (state.password.length < 6) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Password must be at least 6 characters long.',
      );
      return false;
    }

    state = state.copyWith(
      isLoading: false,
      isAuthenticated: true,
      errorMessage: null,
      infoMessage: 'Account created successfully. Redirecting to home...',
    );
    return true;
  }

  Future<bool> sendPasswordReset() async {
    state = state.copyWith(isLoading: true, errorMessage: null, infoMessage: null);
    await Future.delayed(const Duration(milliseconds: 600));

    if (state.email.isEmpty || !state.email.contains('@')) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Enter a valid email to receive password reset instructions.',
      );
      return false;
    }

    state = state.copyWith(
      isLoading: false,
      errorMessage: null,
      infoMessage: 'A reset link has been sent to ${state.email}.',
    );
    return true;
  }

  void logout() {
    state = const AuthSessionState();
  }
}

final authSessionProvider = StateNotifierProvider<AuthSessionNotifier, AuthSessionState>(
  (ref) => AuthSessionNotifier(),
);
