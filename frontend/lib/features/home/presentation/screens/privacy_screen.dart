import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/primary_nav_bar.dart';
import '../../../../core/widgets/site_footer.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SupportPage(
      currentRoute: '/privacy',
      title: 'Privacy Policy',
      sections: [
        SupportSectionData(
          heading: '1. Information We Collect',
          body:
              'At TibebArchive, we collect only the information required to preserve and document Ethiopian textile heritage. This includes profile details, contributed archive records, regional references, and research notes linked to approved submissions.',
        ),
        SupportSectionData(
          heading: '2. How We Use Your Data',
          body:
              'Your information helps us maintain a secure and verifiable traditional registry. We use it to review contributions, attribute work correctly, and preserve reliable cultural records for students and researchers.',
        ),
        SupportSectionData(
          heading: '3. Security',
          body:
              'We use protected workflows and role-based access so sensitive textile knowledge remains responsibly managed and traceable within the platform.',
        ),
      ],
    );
  }
}

class SupportPage extends StatelessWidget {
  const SupportPage({
    required this.currentRoute,
    required this.title,
    required this.sections,
  });

  final String currentRoute;
  final String title;
  final List<SupportSectionData> sections;

  @override
  Widget build(BuildContext context) {
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
                  PrimaryNavBar(currentRoute: currentRoute),
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
                          title,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 24),
                        for (final section in sections) ...[
                          Text(
                            section.heading,
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            section.body,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(height: 24),
                        ],
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
}

class SupportSectionData {
  const SupportSectionData({
    required this.heading,
    required this.body,
  });

  final String heading;
  final String body;
}
