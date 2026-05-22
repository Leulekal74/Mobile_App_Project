import 'package:flutter/material.dart';

import 'privacy_screen.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SupportPage(
      currentRoute: '/terms',
      title: 'Terms of Service',
      sections: [
        SupportSectionData(
          heading: 'Agreement to Terms',
          body:
              'By using TibebArchive, you agree to contribute and review records responsibly, with respect for Ethiopian craft heritage and academic documentation standards.',
        ),
        SupportSectionData(
          heading: 'Contribution Standards',
          body:
              'All submitted pattern specifications, dye formulas, and artisan notes should be accurate, reviewable, and appropriate for a cultural knowledge registry.',
        ),
        SupportSectionData(
          heading: 'Intellectual Property & Credit',
          body:
              'Contributors retain authorship of their submissions while allowing the archive to organize, display, and credit approved records for educational and preservation purposes.',
        ),
      ],
    );
  }
}
