import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_colors.dart';
import 'app_logo.dart';

class PrimaryNavBar extends StatelessWidget {
  const PrimaryNavBar({
    super.key,
    required this.currentRoute,
  });

  final String currentRoute;

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.of(context).size.width < 820;

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
                  children: [
                    _NavLink(
                      label: 'Home',
                      route: '/',
                      active: currentRoute == '/',
                    ),
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
                    _NavLink(
                      label: 'Log in',
                      route: '/login',
                      active: currentRoute == '/login',
                    ),
                    _SignUpButton(onPressed: () => context.go('/signup')),
                  ],
                ),
              ],
            )
          : Row(
              children: [
                const AppLogo(),
                const Spacer(),
                _NavLink(
                  label: 'Home',
                  route: '/',
                  active: currentRoute == '/',
                ),
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
                const SizedBox(width: 18),
                TextButton(
                  onPressed: () => context.go('/login'),
                  child: const Text('Log in'),
                ),
                const SizedBox(width: 8),
                _SignUpButton(onPressed: () => context.go('/signup')),
              ],
            ),
    );
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