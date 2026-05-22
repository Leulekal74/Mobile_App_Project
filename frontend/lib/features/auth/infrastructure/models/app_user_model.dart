import '../../domain/entities/app_user.dart';

/// Infrastructure model used to serialize and deserialize user data.
///
/// Extends the domain [AppUser] entity to preserve the domain contract while
/// adding convenience methods for JSON handling.
class AppUserModel extends AppUser {
  /// Creates a new [AppUserModel] with the same fields as [AppUser].
  AppUserModel({
    required super.id,
    required super.email,
    super.name,
    required super.role,
    required super.createdAt,
  });

  /// Creates a [AppUserModel] from a JSON map.
  ///
  /// Required fields are validated and missing or malformed values throw
  /// a [FormatException]. Optional values are handled gracefully.
  factory AppUserModel.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'] as String?;
    final rawEmail = json['email'] as String?;
    final rawRole = json['role'] as String?;
    final rawCreatedAt = json['createdAt'] as String?;
    final rawName = json['name'] as String?;

    if (rawId == null || rawId.trim().isEmpty) {
      throw FormatException('AppUserModel.fromJson missing or invalid "id"');
    }

    if (rawEmail == null || rawEmail.trim().isEmpty) {
      throw FormatException('AppUserModel.fromJson missing or invalid "email"');
    }

    if (rawRole == null || rawRole.trim().isEmpty) {
      throw FormatException('AppUserModel.fromJson missing or invalid "role"');
    }

    if (rawCreatedAt == null || rawCreatedAt.trim().isEmpty) {
      throw FormatException('AppUserModel.fromJson missing or invalid "createdAt"');
    }

    final parsedCreatedAt = DateTime.tryParse(rawCreatedAt);
    if (parsedCreatedAt == null) {
      throw FormatException('AppUserModel.fromJson invalid "createdAt" format');
    }

    final parsedRole = UserRoleExtension.fromString(rawRole.trim());

    return AppUserModel(
      id: rawId.trim(),
      email: rawEmail.trim(),
      name: rawName?.trim(),
      role: parsedRole,
      createdAt: parsedCreatedAt,
    );
  }

  /// Converts the user model back into JSON format.
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'role': role.name,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Creates a copy of this model with optional overrides.
  ///
  /// This maintains immutability while allowing localized updates.
  @override
  AppUserModel copyWith({
    String? id,
    String? email,
    String? name,
    UserRole? role,
    DateTime? createdAt,
  }) {
    return AppUserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
