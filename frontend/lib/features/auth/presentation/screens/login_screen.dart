import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../providers/auth_session.dart';
import '../widgets/auth_card_shell.dart';
import '../widgets/role_selector.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  UserRole _selectedRole = UserRole.buyer;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthCardShell(
      title: 'Welcome Back',
      subtitle: 'Log in to continue preserving textile records.',
      child: Column(
        children: [
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(labelText: 'Password'),
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Role',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: 8),
          RoleSelector(
            selectedRole: _selectedRole,
            onChanged: (role) => setState(() => _selectedRole = role),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                AuthSessionScope.of(context).login(
                  email: _emailController.text.trim().isEmpty
                      ? 'researcher@tibebarchive.com'
                      : _emailController.text.trim(),
                  role: _selectedRole,
                );
                context.go('/profile');
              },
              child: const Text('Sign In'),
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => context.go('/forgot-password'),
            child: const Text('Forgot password?'),
          ),
          TextButton(
            onPressed: () => context.go('/signup'),
            child: const Text('Need an account? Sign up'),
          ),
        ],
      ),
    );
  }
}
