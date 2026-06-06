import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
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
  test('canWriteProvider allows admins and sellers only', () async {
    final adminContainer = _containerForRole(UserRole.admin);
    addTearDown(adminContainer.dispose);

    expect(await adminContainer.read(authControllerProvider.future), isNotNull);
    expect(adminContainer.read(canWriteProvider), isTrue);

    final sellerContainer = _containerForRole(UserRole.seller);
    addTearDown(sellerContainer.dispose);

    expect(
      await sellerContainer.read(authControllerProvider.future),
      isNotNull,
    );
    expect(sellerContainer.read(canWriteProvider), isTrue);

    final buyerContainer = _containerForRole(UserRole.buyer);
    addTearDown(buyerContainer.dispose);

    expect(await buyerContainer.read(authControllerProvider.future), isNotNull);
    expect(buyerContainer.read(canWriteProvider), isFalse);
  });

  test('PatternsController loads and refreshes repository data', () async {
    final repository = _FakeArchiveRepository();
    final container = ProviderContainer(
      overrides: [archiveRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);

    final initialPatterns = await container.read(
      patternsControllerProvider.future,
    );

    expect(initialPatterns.single.name, 'Cached Pattern');
    expect(repository.forceRefreshRequests, 0);

    await container.read(patternsControllerProvider.notifier).refresh();

    final refreshedPatterns = container.read(patternsControllerProvider).value;
    expect(refreshedPatterns?.single.name, 'Remote Pattern');
    expect(repository.forceRefreshRequests, 1);
  });
}

ProviderContainer _containerForRole(UserRole role) {
  return ProviderContainer(
    overrides: [
      authRepositoryProvider.overrideWithValue(_RestoredAuthRepository(role)),
    ],
  );
}

class _RestoredAuthRepository implements AuthRepository {
  _RestoredAuthRepository(this.role);

  final UserRole role;

  @override
  Future<AuthSession?> restoreSession() async {
    return AuthSession(
      token: 'token',
      user: AppUser(
        id: 'user-1',
        name: 'User',
        email: 'user@example.com',
        role: role,
      ),
    );
  }

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

class _FakeArchiveRepository implements ArchiveRepository {
  int forceRefreshRequests = 0;

  @override
  Future<List<PatternRecord>> getPatterns({bool forceRefresh = false}) async {
    if (forceRefresh) {
      forceRefreshRequests++;
      return const [
        PatternRecord(
          id: 'pattern-2',
          name: 'Remote Pattern',
          region: 'Addis Ababa',
          technique: 'Tablet weave',
          description: 'Fresh archive data',
          threadCount: '96',
          ownerId: 'user-1',
        ),
      ];
    }

    return const [
      PatternRecord(
        id: 'pattern-1',
        name: 'Cached Pattern',
        region: 'Gojjam',
        technique: 'Loom draft',
        description: 'Cached archive data',
        threadCount: '120',
        ownerId: 'user-1',
      ),
    ];
  }

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
