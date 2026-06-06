import 'dart:convert';
import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/app.dart';
import 'package:frontend/features/archive/application/archive_providers.dart';
import 'package:frontend/features/archive/domain/entities/artisan.dart';
import 'package:frontend/features/archive/domain/entities/dye.dart';
import 'package:frontend/features/archive/domain/entities/pattern.dart';
import 'package:frontend/features/archive/domain/repositories/archive_repository.dart';
import 'package:frontend/features/auth/application/auth_controller.dart';
import 'package:frontend/features/auth/domain/entities/app_user.dart';
import 'package:frontend/features/auth/domain/entities/auth_session.dart';
import 'package:frontend/features/auth/domain/repositories/auth_repository.dart';

void main() {
  testWidgets('TibebArchiveApp opens on the home page', (tester) async {
    _stubImageAssets(tester);
    await tester.binding.setSurfaceSize(const Size(1280, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(_GuestAuthRepository()),
          archiveRepositoryProvider.overrideWithValue(
            _EmptyArchiveRepository(),
          ),
        ],
        child: const TibebArchiveApp(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Explore Registry'), findsOneWidget);

    await tester.ensureVisible(find.text('Explore Registry'));
    await tester.tap(find.text('Explore Registry'));
    await tester.pumpAndSettle();

    expect(find.text('Log in to access the archive registry.'), findsOneWidget);
  });
}

void _stubImageAssets(WidgetTester tester) {
  tester.binding.defaultBinaryMessenger.setMockMessageHandler(
    'flutter/assets',
    (message) async {
      final assetKey = utf8.decode(message!.buffer.asUint8List());
      if (assetKey == 'AssetManifest.bin') {
        return const StandardMessageCodec().encodeMessage({
          'assets/images/logo.png': [
            {'asset': 'assets/images/logo.png'},
          ],
          'assets/images/image.png': [
            {'asset': 'assets/images/image.png'},
          ],
        });
      }
      if (assetKey == 'assets/images/logo.png' ||
          assetKey == 'assets/images/image.png') {
        return ByteData.sublistView(base64Decode(_transparentPngBase64));
      }
      return null;
    },
  );
}

const _transparentPngBase64 =
    'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAFgwJ/l0wHFwAAAABJRU5ErkJggg==';

class _GuestAuthRepository implements AuthRepository {
  @override
  Future<AuthSession?> restoreSession() async => null;

  @override
  Future<AuthSession> login({required String email, required String password}) {
    throw UnimplementedError();
  }

  @override
  Future<AuthSession> signup({
    required String name,
    required String email,
    required String password,
    required UserRole role,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<void> logout() async {}
}

class _EmptyArchiveRepository implements ArchiveRepository {
  @override
  Future<List<PatternRecord>> getPatterns({bool forceRefresh = false}) async =>
      const [];

  @override
  Future<List<DyeRecord>> getDyes({bool forceRefresh = false}) async =>
      const [];

  @override
  Future<List<ArtisanRecord>> getArtisans({bool forceRefresh = false}) async =>
      const [];

  @override
  Future<PatternRecord> createPattern(Map<String, dynamic> payload) {
    throw UnimplementedError();
  }

  @override
  Future<PatternRecord> updatePattern(String id, Map<String, dynamic> payload) {
    throw UnimplementedError();
  }

  @override
  Future<void> deletePattern(String id) {
    throw UnimplementedError();
  }

  @override
  Future<DyeRecord> createDye(Map<String, dynamic> payload) {
    throw UnimplementedError();
  }

  @override
  Future<DyeRecord> updateDye(String id, Map<String, dynamic> payload) {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteDye(String id) {
    throw UnimplementedError();
  }

  @override
  Future<ArtisanRecord> createArtisan(Map<String, dynamic> payload) {
    throw UnimplementedError();
  }

  @override
  Future<ArtisanRecord> updateArtisan(String id, Map<String, dynamic> payload) {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteArtisan(String id) {
    throw UnimplementedError();
  }
}
