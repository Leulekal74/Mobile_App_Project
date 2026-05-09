import 'package:flutter/material.dart';

enum UserRole { admin, buyer, seller }

class AuthSession extends ChangeNotifier {
  bool _isLoggedIn = false;
  String _email = '';
  UserRole _role = UserRole.buyer;

  bool get isLoggedIn => _isLoggedIn;
  String get email => _email;
  UserRole get role => _role;

  void login({
    required String email,
    required UserRole role,
  }) {
    _isLoggedIn = true;
    _email = email;
    _role = role;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    _email = '';
    _role = UserRole.buyer;
    notifyListeners();
  }
}

class AuthSessionScope extends InheritedNotifier<AuthSession> {
  const AuthSessionScope({
    super.key,
    required AuthSession session,
    required Widget child,
  }) : super(notifier: session, child: child);

  static AuthSession of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<AuthSessionScope>();
    assert(scope != null, 'AuthSessionScope not found in widget tree.');
    return scope!.notifier!;
  }
}
