import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/auth_controller.dart';
import '../../domain/entities/app_user.dart';
import '../widgets/auth_card_shell.dart';
import '../widgets/role_selector.dart';

final signupNameProvider = StateProvider<String?>((ref) => null);
final signupEmailProvider = StateProvider<String?>((ref) => null);
final signupPasswordProvider = StateProvider<String?>((ref) => null);
final signupConfirmPasswordProvider = StateProvider<String?>((ref) => null);
final signupRoleProvider = StateProvider<String?>((ref) => null);

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _passwordStrengthLabel(String password) {
    if (password.length >= 12) {
      return 'Strong';
    }
    if (password.length >= 8) {
      return 'Medium';
    }
    return 'Weak';
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Consumer(
            builder: (context, ref, child) {
              final authState = ref.watch(authStateProvider);
              final authController = ref.read(authStateProvider.notifier);
              final email = ref.watch(signupEmailProvider) ?? '';
              final password = ref.watch(signupPasswordProvider) ?? '';
              final role = ref.watch(signupRoleProvider);

              if (authState.status == AuthStatus.error &&
                  authState.errorMessage != null) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _showSnackBar(context, authState.errorMessage!);
                });
              }

              if (authState.isAuthenticated) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _showSnackBar(context, 'Account created successfully!');
                  Navigator.of(context).pushReplacementNamed('/home');
                });
              }

              return Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  child: AuthCardShell(
                    title: 'Create your account',
                    isLoading: authState.isLoading,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFormField(
                            keyboardType: TextInputType.name,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              labelText: 'Name',
                              hintText: 'John Doe',
                            ),
                            validator: AuthController.validateName,
                            onChanged: (value) =>
                                ref.read(signupNameProvider.notifier).state = value,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              hintText: 'name@example.com',
                            ),
                            validator: AuthController.validateEmail,
                            onChanged: (value) =>
                                ref.read(signupEmailProvider.notifier).state = value,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            obscureText: true,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              labelText: 'Password',
                            ),
                            validator: AuthController.validatePassword,
                            onChanged: (value) =>
                                ref.read(signupPasswordProvider.notifier).state = value,
                          ),
                          if (password.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Text(
                              'Password strength: ${_passwordStrengthLabel(password)}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                          const SizedBox(height: 16),
                          TextFormField(
                            obscureText: true,
                            textInputAction: TextInputAction.done,
                            decoration: const InputDecoration(
                              labelText: 'Confirm Password',
                            ),
                            validator: (value) {
                              final confirmValue = value ?? '';
                              if (confirmValue.isEmpty) {
                                return 'Please confirm your password.';
                              }
                              if (confirmValue != password) {
                                return 'Passwords do not match.';
                              }
                              return null;
                            },
                            onChanged: (value) => ref
                                .read(signupConfirmPasswordProvider.notifier)
                                .state = value,
                          ),
                          const SizedBox(height: 16),
                          RoleSelector(
                            initialValue: role,
                            onRoleChanged: (selectedRole) {
                              ref
                                  .read(signupRoleProvider.notifier)
                                  .state = selectedRole;
                            },
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: authState.isLoading
                                ? null
                                : () async {
                                    FocusScope.of(context).unfocus();
                                    final formState = _formKey.currentState;
                                    if (formState == null) {
                                      return;
                                    }
                                    if (!formState.validate()) {
                                      return;
                                    }
                                    if (role == null || role.isEmpty) {
                                      _showSnackBar(context, 'Please select a role.');
                                      return;
                                    }

                                    await authController.signup(
                                      email: email.trim(),
                                      password: password,
                                      name: ref.read(signupNameProvider)!.trim(),
                                      role: role == 'artisan'
                                          ? UserRole.artisan
                                          : UserRole.viewer,
                                    );

                                    if (ref.read(authStateProvider).isAuthenticated) {
                                      formState.reset();
                                      ref.read(signupNameProvider.notifier).state = null;
                                      ref.read(signupEmailProvider.notifier).state = null;
                                      ref.read(signupPasswordProvider.notifier).state = null;
                                      ref.read(signupConfirmPasswordProvider.notifier).state = null;
                                      ref.read(signupRoleProvider.notifier).state = null;
                                    }
                                  },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 14),
                              child: Text('Sign up'),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pushReplacementNamed('/login');
                            },
                            child: const Text('Already have an account? Log in'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
