import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/auth_controller.dart';
import '../widgets/auth_card_shell.dart';

final forgotPasswordEmailProvider = StateProvider<String?>((ref) => null);
final forgotPasswordLastRequestProvider = StateProvider<DateTime?>((ref) => null);

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  static const _debounceDuration = Duration(seconds: 30);

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _showSuccessDialog(BuildContext context, String email) async {
    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Reset email sent'),
          content: Text('A password reset link was sent to $email.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final authController = ref.read(authStateProvider.notifier);
    final email = ref.watch(forgotPasswordEmailProvider) ?? '';

    if (authState.status == AuthStatus.error &&
        authState.errorMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _showMessage(context, authState.errorMessage!);
      });
    }

    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: AuthCardShell(
                title: 'Forgot Password',
                isLoading: authState.isLoading,
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.done,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          hintText: 'name@example.com',
                        ),
                        validator: AuthController.validateEmail,
                        onChanged: (value) =>
                            ref.read(forgotPasswordEmailProvider.notifier).state = value,
                        onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
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

                                final now = DateTime.now();
                                final last = ref.read(forgotPasswordLastRequestProvider);
                                if (last != null && now.difference(last) < _debounceDuration) {
                                  final secondsLeft =
                                      _debounceDuration.inSeconds -
                                          now.difference(last).inSeconds;
                                  _showMessage(
                                    context,
                                    'Please wait $secondsLeft seconds before requesting another reset link.',
                                  );
                                  return;
                                }

                                try {
                                  await authController.forgotPassword(email.trim());
                                  if (!mounted) return;
                                  ref.read(forgotPasswordLastRequestProvider.notifier).state = now;
                                  formState.reset();
                                  ref.read(forgotPasswordEmailProvider.notifier).state = null;
                                  await _showSuccessDialog(context, email.trim());
                                  if (!mounted) return;
                                  Navigator.of(context).pushNamed(
                                    '/check-email',
                                    arguments: {'email': email.trim()},
                                  );
                                } catch (error) {
                                  if (!mounted) return;
                                  _showMessage(
                                    context,
                                    error.toString().replaceFirst('Exception: ', ''),
                                  );
                                }
                              },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 14),
                          child: Text('Send Reset Link'),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacementNamed('/login');
                        },
                        child: const Text('Back to login'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
