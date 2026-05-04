import 'package:flutter/material.dart';
import 'package:frontend/application/app_colors.dart';
import 'package:frontend/application/app_theme.dart';
import 'package:frontend/features/auth/presentation/widgets/auth_card_shell.dart';

class CheckEmailScreen extends StatelessWidget {
  static const routeName = '/check-email';

  const CheckEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthCardShell(
      title: 'Check your inbox',
      subtitle: 'We have sent password reset instructions to your email address.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.email_outlined, size: 68, color: AppColors.primary),
          const SizedBox(height: 24),
          Text(
            'Open your email to complete the password reset process. If you do not see it, check your spam folder.',
            textAlign: TextAlign.center,
            style: AppTheme.bodyStyle.copyWith(color: AppColors.onSurfaceVariant),
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: AppTheme.buttonTextStyle,
              ),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: const Text('Back to login'),
            ),
          ),
        ],
      ),
    );
  }
}
