import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_colors.dart';

class SiteFooter extends StatelessWidget {
  const SiteFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final stacked = MediaQuery.of(context).size.width < 720;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(28, 28, 28, 20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.stroke),
      ),
      child: stacked
          ? const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _FooterBrand(),
                SizedBox(height: 24),
                _FooterSupport(),
              ],
            )
          : const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _FooterBrand()),
                SizedBox(width: 30),
                _FooterSupport(),
              ],
            ),
    );
  }
}

class _FooterBrand extends StatelessWidget {
  const _FooterBrand();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'TibebArchive',
          style: TextStyle(
            color: AppColors.brandYellowDeep,
            fontWeight: FontWeight.w800,
            fontSize: 32,
            fontStyle: FontStyle.italic,
          ),
        ),
        SizedBox(height: 10),
        Text(
          'Your trusted home partner',
          style: TextStyle(color: AppColors.textMuted),
        ),
        SizedBox(height: 14),
        Row(
          children: [
            Icon(Icons.camera_alt_outlined),
            SizedBox(width: 10),
            Icon(Icons.send_outlined),
            SizedBox(width: 10),
            Icon(Icons.call_outlined),
            SizedBox(width: 10),
            Icon(Icons.facebook_outlined),
          ],
        ),
        SizedBox(height: 24),
        Text(
          '© 2026 TibebArchive | Addis Ababa, Ethiopia',
          style: TextStyle(color: AppColors.textMuted),
        ),
      ],
    );
  }
}

class _FooterSupport extends StatelessWidget {
  const _FooterSupport();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'SUPPORT',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 24,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 14),
        _FooterLink(label: 'Privacy', route: '/privacy'),
        const SizedBox(height: 8),
        _FooterLink(label: 'FAQ', route: '/faq'),
        const SizedBox(height: 8),
        _FooterLink(label: 'Terms', route: '/terms'),
      ],
    );
  }
}

class _FooterLink extends StatelessWidget {
  const _FooterLink({
    required this.label,
    required this.route,
  });

  final String label;
  final String route;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.go(route),
      child: Text(
        '• $label',
        style: const TextStyle(color: AppColors.textMuted),
      ),
    );
  }
}
