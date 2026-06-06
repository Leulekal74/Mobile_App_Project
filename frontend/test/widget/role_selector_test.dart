import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/features/auth/domain/entities/app_user.dart';
import 'package:frontend/features/auth/presentation/widgets/role_selector.dart';

void main() {
  testWidgets('RoleSelector renders all roles and reports selection changes', (
    tester,
  ) async {
    UserRole selectedRole = UserRole.buyer;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) {
              return RoleSelector(
                selectedRole: selectedRole,
                onChanged: (role) => setState(() => selectedRole = role),
              );
            },
          ),
        ),
      ),
    );

    expect(find.text('Admin'), findsOneWidget);
    expect(find.text('Buyer'), findsOneWidget);
    expect(find.text('Seller'), findsOneWidget);

    await tester.tap(find.text('Seller'));
    await tester.pumpAndSettle();

    expect(selectedRole, UserRole.seller);
  });
}
