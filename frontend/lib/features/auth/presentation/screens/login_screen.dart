import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/auth_controller.dart';
import '../widgets/auth_card_shell.dart';

/// Local provider used only for managing the "Remember me" checkbox state.
final loginRememberMeProvider = StateProvider<bool>((ref) => false);

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _showMessage(BuildContext context, String message) {
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
              final rememberMe = ref.watch(loginRememberMeProvider);

              if (authState.status == AuthStatus.error &&
                  authState.errorMessage != null) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _showMessage(context, authState.errorMessage!);
                });
              }

              if (authState.isAuthenticated) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.of(context).pushReplacementNamed('/home');
                });
              }

              String email = '';
              String password = '';

              return Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  child: AuthCardShell(
                    title: 'Welcome Back',
                    isLoading: authState.isLoading,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              hintText: 'name@example.com',
                            ),
                            validator: AuthController.validateEmail,
                            onSaved: (value) {
                              email = value?.trim() ?? '';
                            },
                            onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            obscureText: true,
                            textInputAction: TextInputAction.done,
                            decoration: const InputDecoration(
                              labelText: 'Password',
                            ),
                            validator: AuthController.validatePassword,
                            onSaved: (value) {
                              password = value ?? '';
                            },
                            onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
                          ),
                          const SizedBox(height: 16),
                          CheckboxListTile(
                            title: const Text('Remember me'),
                            value: rememberMe,
                            contentPadding: EdgeInsets.zero,
                            onChanged: (value) {
                              if (value != null) {
                                ref.read(loginRememberMeProvider.notifier).state = value;
                              }
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

                                    formState.save();
                                    await authController.login(email, password);

                                    if (ref.read(authStateProvider).isAuthenticated) {
                                      formState.reset();
                                      ref.read(loginRememberMeProvider.notifier).state = false;
                                    }
                                  },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 14),
                              child: Text('Login'),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed('/forgot-password');
                            },
                            child: const Text('Forgot password?'),
                          ),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed('/signup');
                            },
                            child: const Text('Create account'),
                          ),
                          // Guest login is not included to keep this screen focused
                          // on authenticated email/password access only.
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
