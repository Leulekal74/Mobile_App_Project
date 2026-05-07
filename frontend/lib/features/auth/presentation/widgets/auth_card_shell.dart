import 'package:flutter/material.dart';
import 'package:frontend/application/app_colors.dart';
import 'package:frontend/application/app_theme.dart';
import 'package:frontend/presentation/widgets/app_logo.dart';
import 'package:frontend/presentation/widgets/primary_nav_bar.dart';

class AuthCardShell extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;
  final String footerText;
  final Widget? footerAction;

  const AuthCardShell({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
    this.footerText = '',
    this.footerAction,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const PrimaryNavBar(),
              const SizedBox(height: 28),
              const Center(child: AppLogo()),
              const SizedBox(height: 24),
              Card(
                elevation: 10,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                color: AppColors.surface,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: AppTheme.headingStyle.copyWith(color: AppColors.onSurface)),
                      const SizedBox(height: 10),
                      Text(subtitle, style: AppTheme.bodyStyle.copyWith(color: AppColors.onSurfaceVariant)),
                      const SizedBox(height: 22),
                      child,
                    ],
                  ),
                ),
              ),
              if (footerText.isNotEmpty || footerAction != null) ...[
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text(footerText, style: AppTheme.captionStyle.copyWith(color: AppColors.onSurfaceVariant))),
                    ?footerAction,
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
