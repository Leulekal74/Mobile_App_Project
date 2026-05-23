import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/screens/check_email_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/signup_screen.dart';
import '../../features/home/presentation/screens/about_screen.dart';
import '../../features/home/presentation/screens/faq_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/home/presentation/screens/privacy_screen.dart';
import '../../features/home/presentation/screens/registry_screen.dart';
import '../../features/home/presentation/screens/terms_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) =>
            const Scaffold(body: Center(child: Text('Home Screen'))),
      ),
      GoRoute(
        path: '/registry',
        builder: (context, state) =>
            const Scaffold(body: Center(child: Text('Registry Screen'))),
      ),
      GoRoute(
        path: '/about',
        builder: (context, state) =>
            const Scaffold(body: Center(child: Text('About Screen'))),
      ),
      GoRoute(
        path: '/privacy',
        builder: (context, state) =>
            const Scaffold(body: Center(child: Text('Privacy Screen'))),
      ),
      GoRoute(
        path: '/faq',
        builder: (context, state) =>
            const Scaffold(body: Center(child: Text('FAQ Screen'))),
      ),
      GoRoute(
        path: '/terms',
        builder: (context, state) =>
            const Scaffold(body: Center(child: Text('Terms Screen'))),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) =>
            const Scaffold(body: Center(child: Text('Login Screen'))),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) =>
            const Scaffold(body: Center(child: Text('Signup Screen'))),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) =>
            const Scaffold(body: Center(child: Text('Forgot Password Screen'))),
      ),
    ],
  );
});
