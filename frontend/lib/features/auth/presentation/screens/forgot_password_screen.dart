import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/application/app_colors.dart';
import 'package:frontend/application/app_theme.dart';
import 'package:frontend/features/auth/presentation/providers/auth_session.dart';
import 'package:frontend/features/auth/presentation/widgets/auth_card_shell.dart';

class ForgotPasswordScreen extends ConsumerWidget {
  static const routeName = '/forgot-password';

  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authSessionProvider);
    final notifier = ref.read(authSessionProvider.notifier);

    return AuthCardShell(
      title: 'Forgot password?',
      subtitle: 'Enter your email and we’ll send you a reset link right away.',
      child: Column(
        children: [
          _AuthTextField(
            label: 'Email',
            initialValue: authState.email,
            hintText: 'test@example.com',
            keyboardType: TextInputType.emailAddress,
            onChanged: notifier.setEmail,
          ),
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
                      final success = await notifier.sendPasswordReset();
                      if (success && context.mounted) {
                        Navigator.pushNamed(context, '/check-email');
                      }
                    },
              child: authState.isLoading
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text('Send reset link'),
            ),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
            child: const Text('Back to login'),
          ),
        ],
      ),
    );
  }
}

class _AuthTextField extends StatelessWidget {
  final String label;
  final String initialValue;
  final String hintText;
  final TextInputType keyboardType;
  final ValueChanged<String> onChanged;

  const _AuthTextField({
    required this.label,
    required this.initialValue,
    required this.onChanged,
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
