import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/application/app_colors.dart';
import 'package:frontend/features/auth/presentation/providers/auth_session.dart';

class RoleSelector extends ConsumerWidget {
  const RoleSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authSessionProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('I am signing up as', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: AuthRole.values.map((role) {
            final isSelected = authState.role == role;
            return ChoiceChip(
              label: Text(_labelForRole(role)),
              selected: isSelected,
              selectedColor: AppColors.primary,
              backgroundColor: AppColors.surfaceVariant,
              labelStyle: TextStyle(
                color: isSelected ? AppColors.onPrimary : AppColors.onSurface,
                fontWeight: FontWeight.w600,
              ),
              onSelected: (_) => ref.read(authSessionProvider.notifier).setRole(role),
            );
          }).toList(),
        ),
      ],
    );
  }

  String _labelForRole(AuthRole role) {
    switch (role) {
      case AuthRole.artisan:
        return 'Artisan';
      case AuthRole.customer:
      default:
        return 'Customer';
    }
  }
}
