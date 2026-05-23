import '../../domain/entities/app_user.dart';
import '../../domain/entities/auth_session.dart';

class AppUserModel extends AppUser {
  const AppUserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.role,
  });

  factory AppUserModel.fromJson(Map<String, dynamic> json) {
    return AppUserModel(
      id: json['id'] as String,
      name: (json['name'] ?? '') as String,
      email: json['email'] as String,
      role: userRoleFromString(json['role'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role.value,
    };
  }
}

class AuthSessionModel extends AuthSession {
  const AuthSessionModel({
    required super.token,
    required AppUserModel super.user,
  });

  factory AuthSessionModel.fromJson(Map<String, dynamic> json) {
    return AuthSessionModel(
      token: json['token'] as String,
      user: AppUserModel.fromJson(json['user'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'user': (user as AppUserModel).toJson(),
    };
  }
}
