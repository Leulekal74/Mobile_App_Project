import 'app_user.dart';

/// Domain entity representing the authenticated session state.
///
/// This includes the authenticated [AppUser], the JWT or access token, and the
/// expiration timestamp for session validation.
class AuthSession {
  /// The authenticated user associated with the session.
  final AppUser user;

  /// The authentication token returned by the backend.
  final String token;

  /// The moment when the token expires and should no longer be used.
  final DateTime expiresAt;

  /// Creates a new immutable [AuthSession].
  const AuthSession({
    required this.user,
    required this.token,
    required this.expiresAt,
  });

  /// Returns a new [AuthSession] with updated values.
  ///
  /// This supports immutable updates while retaining most of the previous state.
  AuthSession copyWith({
    AppUser? user,
    String? token,
    DateTime? expiresAt,
  }) {
    return AuthSession(
      user: user ?? this.user,
      token: token ?? this.token,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }

  /// Converts this session into JSON format for persistence.
  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'token': token,
      'expiresAt': expiresAt.toIso8601String(),
    };
  }

  /// Reconstructs an [AuthSession] from JSON.
  ///
  /// Throws [FormatException] if any required field is missing or malformed.
  factory AuthSession.fromJson(Map<String, dynamic> json) {
    final rawUser = json['user'] as Map<String, dynamic>?;
    final rawToken = json['token'] as String?;
    final rawExpiresAt = json['expiresAt'] as String?;

    if (rawUser == null) {
      throw FormatException('AuthSession.fromJson missing "user"');
    }

    if (rawToken == null || rawToken.trim().isEmpty) {
      throw FormatException('AuthSession.fromJson missing or invalid "token"');
    }

    if (rawExpiresAt == null) {
      throw FormatException('AuthSession.fromJson missing "expiresAt"');
    }

    final parsedExpiresAt = DateTime.tryParse(rawExpiresAt);
    if (parsedExpiresAt == null) {
      throw FormatException('AuthSession.fromJson invalid "expiresAt" format');
    }

    return AuthSession(
      user: AppUser.fromJson(rawUser),
      token: rawToken,
      expiresAt: parsedExpiresAt,
    );
  }

  /// Returns true when the session token has already expired.
  bool isExpired() {
    return expiresAt.isBefore(DateTime.now());
  }

  /// Returns true when the session token is still valid.
  bool get isValid => !isExpired();

  @override
  String toString() {
    return 'AuthSession(user: $user, token: [REDACTED], expiresAt: ${expiresAt.toIso8601String()})';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
      other is AuthSession &&
      other.user == user &&
      other.token == token &&
      other.expiresAt == expiresAt;
  }

  @override
  int get hashCode => Object.hash(user, token, expiresAt);
}
