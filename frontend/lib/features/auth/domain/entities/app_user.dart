enum UserRole { admin, buyer, seller }

extension UserRoleX on UserRole {
  String get value => name;
}

UserRole userRoleFromString(String value) {
  switch (value) {
    case 'admin':
      return UserRole.admin;
    case 'seller':
      return UserRole.seller;
    default:
      return UserRole.buyer;
  }
}

class AppUser {
  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  final String id;
  final String name;
  final String email;
  final UserRole role;
}
