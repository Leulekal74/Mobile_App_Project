import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/primary_nav_bar.dart';
import '../../../../core/widgets/site_footer.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

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
                  const PrimaryNavBar(currentRoute: '/faq'),
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
                      children: [
                        Text(
                          'Common Questions',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 24),
                        const _FaqTile(
                          question:
                              'How do I verify that a traditional weaving pattern is authentic?',
                          answer:
                              'Each record should include source notes, region, and contributor context so it can be reviewed with stronger cultural accuracy.',
                        ),
                        const SizedBox(height: 14),
                        const _FaqTile(
                          question:
                              'What if I find an error in a documented design record?',
                          answer:
                              'You can submit corrected notes through the registry workflow so the archive can maintain clear revisions and proper attribution.',
                        ),
                        const SizedBox(height: 14),
                        const _FaqTile(
                          question:
                              'Can artisans update their regional specialty or ownership?',
                          answer:
                              'Yes. Artisan and pattern details can be updated as records evolve, especially when preserving accurate field documentation.',
                        ),
                        const SizedBox(height: 14),
                        const _FaqTile(
                          question:
                              'Do images or dye recipes stay entirely confidential?',
                          answer:
                              'Access depends on the record type and user role, so sensitive cultural material can be handled more carefully when needed.',
                        ),
                        const SizedBox(height: 14),
                        const _FaqTile(
                          question:
                              'Who can review new textile archive records?',
                          answer:
                              'Review access is typically given to approved researchers, admins, or designated contributors based on the archive workflow.',
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
}

class _FaqTile extends StatelessWidget {
  const _FaqTile({
    required this.question,
    required this.answer,
  });

  final String question;
  final String answer;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.stroke),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        shape: const Border(),
        collapsedShape: const Border(),
        iconColor: AppColors.textPrimary,
        collapsedIconColor: AppColors.textPrimary,
        title: Text(
          question,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              answer,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
