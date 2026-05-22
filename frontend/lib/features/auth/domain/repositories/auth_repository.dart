import '../entities/auth_session.dart';
import '../entities/app_user.dart';

/// Base repository contract for authentication-related operations.
///
/// Implementations must map backend and local persistence details to domain
/// behavior, while throwing domain-specific exceptions when failures occur.
abstract class AuthRepository {
  /// Attempts to authenticate a user using email and password.
  ///
  /// Returns an [AuthSession] when login succeeds.
  /// Throws [AuthException] for invalid credentials or validation failures.
  /// Throws [NetworkException] for connectivity issues.
  /// Throws [ServerException] for unexpected backend response states.
  Future<AuthSession> login(String email, String password);

  /// Registers a new user with the backend and returns a valid session.
  ///
  /// Throws [AuthException] when the input is invalid or account creation fails.
  /// Throws [NetworkException] when network communication fails.
  /// Throws [ServerException] when the backend is unable to process the request.
  Future<AuthSession> signup({
    required String email,
    required String password,
    required String name,
    required UserRole role,
  });

  /// Initiates the forgot password flow for the given email address.
  ///
  /// Throws [AuthException] when the email is invalid or the request is rejected.
  /// Throws [NetworkException] for connectivity failures.
  /// Throws [ServerException] for unexpected response errors.
  Future<void> forgotPassword(String email);

  /// Resets a forgotten password using the provided reset token.
  ///
  /// Throws [AuthException] when the token or new password is invalid.
  /// Throws [NetworkException] for connection issues.
  /// Throws [ServerException] when the backend cannot complete the operation.
  Future<void> resetPassword({
    required String token,
    required String newPassword,
  });

  /// Clears the active authentication session.
  ///
  /// This should remove any stored token and local session state.
  Future<void> logout();

  /// Returns the currently cached authentication session if present.
  ///
  /// Returns null when no authenticated session exists locally.
  Future<AuthSession?> getCurrentSession();

  /// Returns true when the user is currently logged in.
  ///
  /// This typically checks stored session validity and token expiration.
  Future<bool> isLoggedIn();
}

/// Base exception for authentication domain errors.
class AuthException implements Exception {
  final String message;

  AuthException(this.message);

  @override
  String toString() => 'AuthException: $message';
}

/// Exception thrown when network connectivity prevents completion.
class NetworkException implements Exception {
  final String message;

  NetworkException([this.message = 'Network connection error']);

  @override
  String toString() => 'NetworkException: $message';
}

/// Exception thrown when the backend returns an unexpected or invalid response.
class ServerException implements Exception {
  final String message;

  ServerException([this.message = 'Server error occurred']);

  @override
  String toString() => 'ServerException: $message';
}
