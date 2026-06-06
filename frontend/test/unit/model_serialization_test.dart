import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/features/archive/infrastructure/models/artisan_model.dart';
import 'package:frontend/features/archive/infrastructure/models/dye_model.dart';
import 'package:frontend/features/archive/infrastructure/models/pattern_model.dart';
import 'package:frontend/features/auth/domain/entities/app_user.dart';
import 'package:frontend/features/auth/infrastructure/models/app_user_model.dart';

void main() {
  group('archive models', () {
    test('PatternModel round-trips JSON', () {
      const pattern = PatternModel(
        id: 'pattern-1',
        name: 'Tibeb Border Matrix',
        region: 'Gojjam',
        technique: 'Loom draft',
        description: 'Repeated edge motif',
        threadCount: '120',
        ownerId: 'user-1',
      );

      expect(
        PatternModel.fromJson(pattern.toJson()).toJson(),
        pattern.toJson(),
      );
    });

    test('DyeModel supplies safe defaults for optional fields', () {
      final dye = DyeModel.fromJson({'id': 'dye-1', 'name': 'Kosso Bark'});

      expect(dye.sourceMaterial, isEmpty);
      expect(dye.region, isEmpty);
      expect(dye.formula, isEmpty);
      expect(dye.notes, isEmpty);
      expect(dye.ownerId, isEmpty);
    });

    test('ArtisanModel serializes experience years', () {
      const artisan = ArtisanModel(
        id: 'artisan-1',
        name: 'Almaz',
        specialty: 'Weaving',
        region: 'Addis Ababa',
        experienceYears: 12,
        bio: 'Master artisan',
        ownerId: 'user-1',
      );

      expect(artisan.toJson()['experienceYears'], 12);
      expect(ArtisanModel.fromJson(artisan.toJson()).experienceYears, 12);
    });
  });

  group('auth models', () {
    test('AppUserModel maps role values', () {
      final user = AppUserModel.fromJson({
        'id': 'user-1',
        'name': 'Marta',
        'email': 'marta@example.com',
        'role': 'seller',
      });

      expect(user.role, UserRole.seller);
      expect(user.toJson()['role'], 'seller');
    });

    test('unknown role values fall back to buyer', () {
      expect(userRoleFromString('researcher'), UserRole.buyer);
    });
  });
}
