import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/app_user.dart';

class RoleSelector extends StatelessWidget {
  const RoleSelector({
    super.key,
    required this.selectedRole,
    required this.onChanged,
  });

  final UserRole selectedRole;
  final ValueChanged<UserRole> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: UserRole.values.map((role) {
        final selected = role == selectedRole;
        return ChoiceChip(
          selected: selected,
          label: Text(_label(role)),
          selectedColor: AppColors.brandYellow,
          backgroundColor: AppColors.softYellow,
          labelStyle: TextStyle(
            color: selected ? Colors.white : AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
          side: BorderSide.none,
          onSelected: (_) => onChanged(role),
        );
      }).toList(),
    );
  }

  String _label(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return 'Admin';
      case UserRole.buyer:
        return 'Buyer';
      case UserRole.seller:
        return 'Seller';
    }
  }
}
