import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/primary_nav_bar.dart';
import '../../../../core/widgets/site_footer.dart';
import '../../../archive/application/archive_providers.dart';
import '../../../auth/application/auth_controller.dart';
import '../../../auth/domain/entities/app_user.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final session = authState.value;

    if (authState.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (session == null) {
      return Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Please log in to access your dashboard.'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.go('/login'),
                  child: const Text('Go to Login'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final patterns = ref.watch(patternsControllerProvider).value ?? const [];
    final dyes = ref.watch(dyesControllerProvider).value ?? const [];
    final artisans = ref.watch(artisansControllerProvider).value ?? const [];

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1180),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const PrimaryNavBar(currentRoute: '/profile'),
                  const SizedBox(height: 28),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(color: AppColors.stroke),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome, ${session.user.name}',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '${session.user.email} • ${session.user.role.name.toUpperCase()}',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 22),
                        Wrap(
                          spacing: 14,
                          runSpacing: 14,
                          children: [
                            _ProfileTile(
                              title: 'Patterns',
                              value: '${patterns.length}',
                              color: AppColors.softYellow,
                            ),
                            _ProfileTile(
                              title: 'Dyes',
                              value: '${dyes.length}',
                              color: const Color(0xFFFFF0CF),
                            ),
                            _ProfileTile(
                              title: 'Artisans',
                              value: '${artisans.length}',
                              color: const Color(0xFFF2F7FF),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Text(
                          _roleSummary(session.user.role),
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 20),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            ElevatedButton(
                              onPressed: () => context.go('/registry'),
                              child: const Text('Open Registry'),
                            ),
                            OutlinedButton(
                              onPressed: () async {
                                await ref
                                    .read(authControllerProvider.notifier)
                                    .logout();
                                if (context.mounted) context.go('/');
                              },
                              child: const Text('Log out'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const SiteFooter(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _roleSummary(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return 'Admins can create, update, and delete all archive records.';
      case UserRole.seller:
        return 'Sellers can manage the records they created and view the full registry.';
      case UserRole.buyer:
        return 'Buyers have read-only access to review textile documentation.';
    }
  }
}

class _ProfileTile extends StatelessWidget {
  const _ProfileTile({
    required this.title,
    required this.value,
    required this.color,
  });

  final String title;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textMuted,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
