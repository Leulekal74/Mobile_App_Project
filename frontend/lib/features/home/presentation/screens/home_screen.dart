import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/primary_nav_bar.dart';
import '../../../../core/widgets/site_footer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.of(context).size.width > 980;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1180),
              child: Column(
                children: [
                  const PrimaryNavBar(currentRoute: '/'),
                  const SizedBox(height: 34),
                  wide
                      ? const Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(flex: 5, child: _HeroImagePanel()),
                            SizedBox(width: 44),
                            Expanded(flex: 4, child: _HeroCopyPanel()),
                          ],
                        )
                      : const Column(
                          children: [
                            _HeroImagePanel(),
                            SizedBox(height: 28),
                            _HeroCopyPanel(),
                          ],
                        ),
                  const SizedBox(height: 44),
                  const SiteFooter(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HeroImagePanel extends StatelessWidget {
  const _HeroImagePanel();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final panelHeight = width < 700 ? 360.0 : 440.0;

    return SizedBox(
      height: panelHeight,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: AppColors.stroke),
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: Image.asset(
                'assets/images/image.png',
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
            Positioned(
              left: 14,
              bottom: 14,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x15000000),
                      blurRadius: 18,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.location_on_outlined, size: 18),
                    SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Master Artisans',
                          style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 11,
                          ),
                        ),
                        Text(
                          '150+ Registered Weaver',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroCopyPanel extends StatelessWidget {
  const _HeroCopyPanel();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ADDIS ABABA FIELDWORK NETWORK',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.blueAccent,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 14),
        RichText(
          text: TextSpan(
            style: theme.textTheme.displaySmall,
            children: const [
              TextSpan(text: 'Preserving Ethiopia\'s\n'),
              TextSpan(
                text: 'Textile DNA.',
                style: TextStyle(color: AppColors.blueAccent),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Text(
          'A technical database for weaving patterns, dye formulas, and artisan knowledge built for students and researchers.',
          style: theme.textTheme.bodyLarge,
        ),
        const SizedBox(height: 30),
        Wrap(
          spacing: 22,
          runSpacing: 12,
          children: const [
            _TrustItem(
              icon: Icons.verified_user_outlined,
              label: 'Insured work',
            ),
            _TrustItem(icon: Icons.thumb_up_alt_outlined, label: 'Guaranteed'),
            _TrustItem(
              icon: Icons.support_agent_outlined,
              label: '24/7 Concierge',
            ),
          ],
        ),
        const SizedBox(height: 26),
        ElevatedButton(
          onPressed: () => context.go('/registry'),
          child: const Text('Explore Registry'),
        ),
      ],
    );
  }
}

class _TrustItem extends StatelessWidget {
  const _TrustItem({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: AppColors.textPrimary),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
        ),
      ],
    );
  }
}
