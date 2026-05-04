import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/application/app_colors.dart';
import 'package:frontend/application/app_theme.dart';
import 'package:frontend/features/auth/presentation/providers/auth_session.dart';
import 'package:frontend/features/auth/presentation/widgets/auth_card_shell.dart';
import 'package:frontend/features/auth/presentation/widgets/role_selector.dart';

class LoginScreen extends ConsumerWidget {
  static const routeName = '/login';

  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authSessionProvider);
    final notifier = ref.read(authSessionProvider.notifier);

    return AuthCardShell(
      title: 'Welcome back',
      subtitle: 'Sign in to continue to the app and open your artisan dashboard or customer feed.',
      child: Column(
        children: [
          _AuthTextField(
            label: 'Email',
            initialValue: authState.email,
            hintText: 'test@example.com',
            keyboardType: TextInputType.emailAddress,
            onChanged: notifier.setEmail,
          ),
          const SizedBox(height: 16),
          _AuthTextField(
            label: 'Password',
            initialValue: authState.password,
            hintText: '123456',
            obscureText: true,
            onChanged: notifier.setPassword,
          ),
          const SizedBox(height: 16),
          RoleSelector(),
          const SizedBox(height: 20),
          if (authState.errorMessage != null) ...[
            Text(authState.errorMessage!, style: const TextStyle(color: Colors.redAccent)),
            const SizedBox(height: 12),
          ],
          if (authState.infoMessage != null) ...[
            Text(authState.infoMessage!, style: const TextStyle(color: Colors.green)),
            const SizedBox(height: 12),
          ],
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: AppTheme.buttonTextStyle,
              ),
              onPressed: authState.isLoading
                  ? null
                  : () async {
                      final success = await notifier.login();
                      if (success && context.mounted) {
                        Navigator.pushReplacementNamed(context, '/home');
                      }
                    },
              child: authState.isLoading
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text('Log in'),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/signup'),
                child: const Text('Create account'),
              ),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/forgot-password'),
                child: const Text('Forgot password?'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AuthTextField extends StatelessWidget {
  final String label;
  final String initialValue;
  final bool obscureText;
  final String hintText;
  final TextInputType keyboardType;
  final ValueChanged<String> onChanged;

  const _AuthTextField({
    required this.label,
    required this.initialValue,
    required this.onChanged,
    this.obscureText = false,
    this.hintText = '',
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTheme.inputLabelStyle),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: initialValue,
          obscureText: obscureText,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hintText,
            filled: true,
            fillColor: AppColors.inputBackground,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
          ),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
