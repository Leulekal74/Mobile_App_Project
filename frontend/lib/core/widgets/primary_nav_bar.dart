import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/application/auth_controller.dart';
import '../constants/app_colors.dart';
import 'app_logo.dart';

class PrimaryNavBar extends ConsumerWidget {
  const PrimaryNavBar({
    super.key,
    required this.currentRoute,
  });

  final String currentRoute;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final compact = MediaQuery.of(context).size.width < 820;
    final session = ref.watch(authControllerProvider).value;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.stroke),
      ),
      child: compact
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppLogo(),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _buildActions(context, ref, session != null),
                ),
              ],
            )
          : Row(
              children: [
                const AppLogo(),
                const Spacer(),
                ..._buildActions(context, ref, session != null),
              ],
            ),
    );
  }

  List<Widget> _buildActions(
    BuildContext context,
    WidgetRef ref,
    bool signedIn,
  ) {
    return [
      _NavLink(label: 'Home', route: '/', active: currentRoute == '/'),
      _NavLink(
        label: 'Registry',
        route: '/registry',
        active: currentRoute == '/registry',
      ),
      _NavLink(
        label: 'About',
        route: '/about',
        active: currentRoute == '/about',
      ),
      if (signedIn)
        _NavLink(
          label: 'Dashboard',
          route: '/profile',
          active: currentRoute == '/profile',
        ),
      const SizedBox(width: 8),
      if (!signedIn)
        TextButton(
          onPressed: () => context.go('/login'),
          child: const Text('Log in'),
        ),
      if (!signedIn) _SignUpButton(onPressed: () => context.go('/signup')),
      if (signedIn)
        TextButton(
          onPressed: () async {
            await ref.read(authControllerProvider.notifier).logout();
            if (context.mounted) {
              context.go('/');
            }
          },
          child: const Text('Log out'),
        ),
    ];
  }
}

class _NavLink extends StatelessWidget {
  const _NavLink({
    required this.label,
    required this.route,
    required this.active,
  });

  final String label;
  final String route;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: () => context.go(route),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: active ? AppColors.softYellow : Colors.transparent,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: active ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

class _SignUpButton extends StatelessWidget {
  const _SignUpButton({required this.onPressed});

  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: AppColors.brandYellow,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      ),
      child: const Text('Sign Up'),
    );
  }
}