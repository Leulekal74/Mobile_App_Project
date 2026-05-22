import 'package:flutter/material.dart';

/// Dropdown field for selecting an account role.
///
/// Only `artisan` and `viewer` roles are available for selection.
class RoleSelector extends StatefulWidget {
  const RoleSelector({
    super.key,
    required this.onRoleChanged,
    this.initialValue,
    this.labelText = 'Role',
  });

  final ValueChanged<String> onRoleChanged;
  final String? initialValue;
  final String labelText;

  @override
  State<RoleSelector> createState() => _RoleSelectorState();
}

class _RoleSelectorState extends State<RoleSelector> {
  String? _selectedRole;

  @override
  void initState() {
    super.initState();
    _selectedRole = widget.initialValue;
  }

  @override
  void didUpdateWidget(covariant RoleSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue) {
      _selectedRole = widget.initialValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DropdownButtonFormField<String>(
      initialValue: _selectedRole,
      decoration: InputDecoration(
        labelText: widget.labelText,
        helperText: 'Select your account type',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a role.';
        }
        return null;
      },
      items: [
        DropdownMenuItem(
          value: 'artisan',
          child: Row(
            children: [
              Icon(Icons.person, color: theme.colorScheme.primary),
              const SizedBox(width: 12),
              const Text('Artisan'),
            ],
          ),
        ),
        DropdownMenuItem(
          value: 'viewer',
          child: Row(
            children: [
              Icon(Icons.visibility, color: theme.colorScheme.primary),
              const SizedBox(width: 12),
              const Text('Viewer'),
            ],
          ),
        ),
      ],
      onChanged: (value) {
        setState(() {
          _selectedRole = value;
        });
        if (value != null) {
          widget.onRoleChanged(value);
        }
      },
      iconEnabledColor: theme.colorScheme.primary,
      dropdownColor: theme.cardColor,
    );
  }
}
