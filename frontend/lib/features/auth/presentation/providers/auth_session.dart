import 'package:flutter/widgets.dart';

/// Lightweight application session scope used by the router.
///
/// This provider file is intentionally separate from the domain auth session
/// entity so the application shell can manage routing state independently.
class AuthSession {
  const AuthSession();
}

/// Inherited widget providing the active auth session to descendants.
class AuthSessionScope extends InheritedWidget {
  const AuthSessionScope({
    super.key,
    required this.session,
    required super.child,
  });

  final AuthSession session;

  static AuthSessionScope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AuthSessionScope>();
    if (scope == null) {
      throw FlutterError('AuthSessionScope not found in context');
    }
    return scope;
  }

  @override
  bool updateShouldNotify(covariant AuthSessionScope oldWidget) {
    return session != oldWidget.session;
  }
}
