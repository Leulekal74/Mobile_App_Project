import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/entities/app_user.dart';
import '../domain/entities/auth_session.dart';
import '../domain/repositories/auth_repository.dart';
import '../infrastructure/datasources/auth_local_data_source.dart' show AuthLocalDataSource;
import '../infrastructure/datasources/auth_remote_data_source.dart' show AuthRemoteDataSource;
import '../infrastructure/repositories/auth_repository_impl.dart';

/// Represents authentication state for the UI.
///
/// Uses a simple enum to distinguish loading, authenticated, unauthenticated,
/// and error states with optional user and session details.
enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
}

/// Immutable state object used by [AuthController].
class AuthState {
  const AuthState({
    required this.status,
    this.user,
    this.session,
    this.errorMessage,
  });

  final AuthStatus status;
  final AppUser? user;
  final AuthSession? session;
  final String? errorMessage;

  bool get isLoading => status == AuthStatus.loading;
  bool get isAuthenticated => status == AuthStatus.authenticated;

  AuthState copyWith({
    AuthStatus? status,
    AppUser? user,
    AuthSession? session,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      session: session ?? this.session,
      errorMessage: errorMessage,
    );
  }

  @override
  String toString() {
    return 'AuthState(status: $status, user: $user, session: $session, errorMessage: $errorMessage)';
  }
}

/// State notifier responsible for authentication flows.
class AuthController extends StateNotifier<AuthState> {
  AuthController({required AuthRepository repository})
      : _repository = repository,
        super(const AuthState(status: AuthStatus.initial));

  final AuthRepository _repository;

  /// Attempt to authenticate an existing user.
  Future<void> login(String email, String password) async {
    final validationError = validateEmail(email) ?? validatePassword(password);
    if (validationError != null) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: validationError,
      );
      return;
    }

    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);

    try {
      final session = await _repository.login(email.trim(), password);
      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: session.user,
        session: session,
        errorMessage: null,
      );
    } catch (error) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: _messageFromError(error),
      );
    }
  }

  /// Register a new user and automatically persist the session.
  Future<void> signup({
    required String email,
    required String password,
    required String name,
    required UserRole role,
  }) async {
    final validationError =
        validateEmail(email) ?? validatePassword(password) ?? validateName(name);
    if (validationError != null) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: validationError,
      );
      return;
    }

    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);

    try {
      final session = await _repository.signup(
        email: email.trim(),
        password: password,
        name: name.trim(),
        role: role,
      );

      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: session.user,
        session: session,
        errorMessage: null,
      );
    } catch (error) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: _messageFromError(error),
      );
    }
  }

  /// Starts a forgot password flow by email.
  Future<void> forgotPassword(String email) async {
    final validationError = validateEmail(email);
    if (validationError != null) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: validationError,
      );
      return;
    }

    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);

    try {
      await _repository.forgotPassword(email.trim());
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: 'Password recovery email sent.',
      );
    } catch (error) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: _messageFromError(error),
      );
    }
  }

  /// Completes a password reset using the reset token.
  Future<void> resetPassword(String token, String newPassword) async {
    if (token.trim().isEmpty) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Reset token is required.',
      );
      return;
    }

    final validationError = validatePassword(newPassword);
    if (validationError != null) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: validationError,
      );
      return;
    }

    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);

    try {
      await _repository.resetPassword(token: token.trim(), newPassword: newPassword);
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: 'Password reset successful. Please sign in.',
      );
    } catch (error) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: _messageFromError(error),
      );
    }
  }

  /// Logout and clear all authentication state.
  Future<void> logout() async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);

    try {
      await _repository.logout();
      state = const AuthState(status: AuthStatus.unauthenticated);
    } catch (error) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: _messageFromError(error),
      );
    }
  }

  /// Verifies current session state on app startup.
  Future<void> checkAuthStatus() async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);

    try {
      final session = await _repository.getCurrentSession();
      if (session != null && !session.isExpired()) {
        state = state.copyWith(
          status: AuthStatus.authenticated,
          user: session.user,
          session: session,
          errorMessage: null,
        );
      } else {
        state = const AuthState(status: AuthStatus.unauthenticated);
      }
    } catch (error) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: _messageFromError(error),
      );
    }
  }

  /// Validates email format for user-facing forms.
  static String? validateEmail(String? email) {
    if (email == null || email.trim().isEmpty) {
      return 'Email is required.';
    }

    const emailPattern =
        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,}\$';
    final regex = RegExp(emailPattern);
    if (!regex.hasMatch(email.trim())) {
      return 'Please enter a valid email address.';
    }
    return null;
  }

  /// Validates password strength for user-facing forms.
  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password is required.';
    }
    if (password.length < 8) {
      return 'Password must be at least 8 characters long.';
    }
    return null;
  }

  /// Validates name input for user-facing forms.
  static String? validateName(String? name) {
    if (name == null || name.trim().isEmpty) {
      return 'Name is required.';
    }
    return null;
  }

  String _messageFromError(Object error) {
    if (error is AuthException ||
        error is NetworkException ||
        error is ServerException) {
      return error.toString().split(': ').length > 1
          ? error.toString().split(': ').sublist(1).join(': ').trim()
          : error.toString();
    }
    return 'An unexpected error occurred. Please try again.';
  }
}

/// Provider for the remote auth data source.
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>(
  (ref) => AuthRemoteDataSource(),
);

/// Provider for the local auth data source.
final authLocalDataSourceProvider = Provider<AuthLocalDataSource>(
  (ref) => AuthLocalDataSource(),
);

/// Provider for the auth repository implementation.
final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(
    remoteDataSource: ref.read(authRemoteDataSourceProvider),
    localDataSource: ref.read(authLocalDataSourceProvider),
  ),
);

/// Provider for authentication state and actions.
final authStateProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) => AuthController(repository: ref.read(authRepositoryProvider)),
);
