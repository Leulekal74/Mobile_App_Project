import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../providers/auth_session.dart';
import '../widgets/auth_card_shell.dart';
import '../widgets/role_selector.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  UserRole _selectedRole = UserRole.seller;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthCardShell(
      title: 'Create Account',
      subtitle: 'Join the archive with a clean role-based sign up flow.',
      child: Column(
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Full name'),
          ),
          const SizedBox(height: 12),
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
              'Select role',
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
                      ? 'new@tibebarchive.com'
                      : _emailController.text.trim(),
                  role: _selectedRole,
                );
                context.go('/profile');
              },
              child: const Text('Sign Up'),
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => context.go('/login'),
            child: const Text('Already have an account? Log in'),
          ),
        ],
      ),
    );
  }
}
