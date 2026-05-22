/// Domain entity representing an authenticated application user.
///
/// This class is intentionally immutable and includes validation logic
/// to ensure that only valid user instances are created.
class AppUser {
  /// Unique identifier for the user.
  /// Must be non-empty.
  final String id;

  /// Email address of the user.
  /// Must be a valid email format.
  final String email;

  /// Optional display name or full name of the user.
  final String? name;

  /// Role assigned to the user for authorization checks.
  final UserRole role;

  /// Timestamp indicating when the user account was created.
  final DateTime createdAt;

  /// Creates a new immutable [AppUser].
  ///
  /// Performs validation on [id] and [email] to prevent invalid domain state.
  AppUser({
    required this.id,
    required this.email,
    this.name,
    required this.role,
    required this.createdAt,
  }) : assert(id.trim().isNotEmpty, 'User id cannot be empty'),
       assert(_isValidEmail(email), 'Email must be a valid format');

  /// Creates a new [AppUser] based on an existing instance with selective updates.
  ///
  /// This is useful for keeping the entity immutable while making small changes.
  AppUser copyWith({
    String? id,
    String? email,
    String? name,
    UserRole? role,
    DateTime? createdAt,
  }) {
    return AppUser(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Converts the user entity into a JSON map suitable for persistence or API transport.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'role': role.name,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Reconstructs an [AppUser] from JSON data.
  ///
  /// Throws [FormatException] if required fields are missing or invalid.
  factory AppUser.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'] as String?;
    final rawEmail = json['email'] as String?;
    final rawRole = json['role'] as String?;
    final rawCreatedAt = json['createdAt'] as String?;

    if (rawId == null || rawId.trim().isEmpty) {
      throw FormatException('AppUser.fromJson missing or invalid "id"');
    }

    if (rawEmail == null || !_isValidEmail(rawEmail)) {
      throw FormatException('AppUser.fromJson missing or invalid "email"');
    }

    if (rawRole == null) {
      throw FormatException('AppUser.fromJson missing "role"');
    }

    if (rawCreatedAt == null) {
      throw FormatException('AppUser.fromJson missing "createdAt"');
    }

    final parsedRole = UserRoleExtension.fromString(rawRole);
    final parsedCreatedAt = DateTime.tryParse(rawCreatedAt);

    if (parsedCreatedAt == null) {
      throw FormatException('AppUser.fromJson invalid "createdAt" format');
    }

    return AppUser(
      id: rawId,
      email: rawEmail,
      name: json['name'] as String?,
      role: parsedRole,
      createdAt: parsedCreatedAt,
    );
  }

  @override
  String toString() {
    return 'AppUser(id: $id, email: $email, name: $name, role: ${role.name}, createdAt: ${createdAt.toIso8601String()})';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
      other is AppUser &&
      other.id == id &&
      other.email == email &&
      other.name == name &&
      other.role == role &&
      other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return Object.hash(id, email, name, role, createdAt);
  }

  /// Validates that [value] is a plausible email address.
  ///
  /// Uses a simple regex to enforce basic email shape without overfitting.
  static bool _isValidEmail(String value) {
    const emailPattern =
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,}\$';
    return RegExp(emailPattern).hasMatch(value.trim());
  }
}

/// Supported application user roles.
///
/// These roles are used for authorization decisions in the domain layer and
/// can be extended if new role types are introduced.
enum UserRole {
  admin,
  artisan,
  viewer,
}

extension UserRoleExtension on UserRole {
  /// Converts the enum to its string representation.
  String get name {
    return toString().split('.').last;
  }

  /// Parses a string value into a [UserRole].
  static UserRole fromString(String value) {
    switch (value) {
      case 'admin':
        return UserRole.admin;
      case 'artisan':
        return UserRole.artisan;
      case 'viewer':
        return UserRole.viewer;
      default:
        throw FormatException('Unknown UserRole: $value');
    }
  }
}
