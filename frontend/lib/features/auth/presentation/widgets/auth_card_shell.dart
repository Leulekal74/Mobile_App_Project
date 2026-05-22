import 'package:flutter/material.dart';

/// A reusable shell for authentication cards.
///
/// Provides a centered card layout with optional title, child content,
/// actions, and a loading overlay to support responsive auth screens.
class AuthCardShell extends StatelessWidget {
  const AuthCardShell({
    super.key,
    this.title,
    this.child,
    this.actions,
    this.isLoading = false,
  });

  final String? title;
  final Widget? child;
  final List<Widget>? actions;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardColor = theme.cardColor;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 450),
        child: Stack(
          children: [
            Card(
              elevation: 4,
              color: cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (title != null) ...[
                      Text(
                        title!,
                        style: theme.textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 16),
                    ],
                    if (child != null) child!,
                    if (actions != null) ...[
                      const SizedBox(height: 24),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        alignment: WrapAlignment.end,
                        children: actions!,
                      ),
                    ],
                  ],
                ),
              ),
            ),
            if (isLoading)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface.withAlpha((0.75 * 255).round()),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
