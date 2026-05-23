import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/core_providers.dart';
import '../../auth/application/auth_controller.dart';
import '../../auth/domain/entities/auth_session.dart';
import '../../auth/domain/entities/app_user.dart';
import '../domain/entities/artisan.dart';
import '../domain/entities/dye.dart';
import '../domain/entities/pattern.dart';
import '../domain/repositories/archive_repository.dart';
import '../infrastructure/datasources/archive_local_data_source.dart';
import '../infrastructure/datasources/archive_remote_data_source.dart';
import '../infrastructure/repositories/archive_repository_impl.dart';

final archiveLocalDataSourceProvider = Provider<ArchiveLocalDataSource>((ref) {
  return ArchiveLocalDataSource(ref.watch(appDatabaseProvider));
});

final archiveRemoteDataSourceProvider = Provider<ArchiveRemoteDataSource>((ref) {
  return ArchiveRemoteDataSource(ref.watch(apiClientProvider));
});

final archiveRepositoryProvider = Provider<ArchiveRepository>((ref) {
  return ArchiveRepositoryImpl(
    localDataSource: ref.watch(archiveLocalDataSourceProvider),
    remoteDataSource: ref.watch(archiveRemoteDataSourceProvider),
    sessionReader: () {
      final session = ref.read(authControllerProvider).value;
      if (session == null) {
        throw Exception('You must be logged in to access archive data.');
      }
      return session;
    },
  );
});

class PatternsController extends AsyncNotifier<List<PatternRecord>> {
  @override
  Future<List<PatternRecord>> build() async {
    return ref.read(archiveRepositoryProvider).getPatterns();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(archiveRepositoryProvider).getPatterns(forceRefresh: true),
    );
  }

  Future<void> save(Map<String, dynamic> payload, {String? id}) async {
    await (id == null
        ? ref.read(archiveRepositoryProvider).createPattern(payload)
        : ref.read(archiveRepositoryProvider).updatePattern(id, payload));
    await refresh();
  }

  Future<void> remove(String id) async {
    await ref.read(archiveRepositoryProvider).deletePattern(id);
    await refresh();
  }
}

class DyesController extends AsyncNotifier<List<DyeRecord>> {
  @override
  Future<List<DyeRecord>> build() async {
    return ref.read(archiveRepositoryProvider).getDyes();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(archiveRepositoryProvider).getDyes(forceRefresh: true),
    );
  }

  Future<void> save(Map<String, dynamic> payload, {String? id}) async {
    await (id == null
        ? ref.read(archiveRepositoryProvider).createDye(payload)
        : ref.read(archiveRepositoryProvider).updateDye(id, payload));
    await refresh();
  }

  Future<void> remove(String id) async {
    await ref.read(archiveRepositoryProvider).deleteDye(id);
    await refresh();
  }
}

class ArtisansController extends AsyncNotifier<List<ArtisanRecord>> {
  @override
  Future<List<ArtisanRecord>> build() async {
    return ref.read(archiveRepositoryProvider).getArtisans();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(archiveRepositoryProvider).getArtisans(forceRefresh: true),
    );
  }

  Future<void> save(Map<String, dynamic> payload, {String? id}) async {
    await (id == null
        ? ref.read(archiveRepositoryProvider).createArtisan(payload)
        : ref.read(archiveRepositoryProvider).updateArtisan(id, payload));
    await refresh();
  }

  Future<void> remove(String id) async {
    await ref.read(archiveRepositoryProvider).deleteArtisan(id);
    await refresh();
  }
}

final patternsControllerProvider =
    AsyncNotifierProvider<PatternsController, List<PatternRecord>>(PatternsController.new);

final dyesControllerProvider =
    AsyncNotifierProvider<DyesController, List<DyeRecord>>(DyesController.new);

final artisansControllerProvider =
    AsyncNotifierProvider<ArtisansController, List<ArtisanRecord>>(ArtisansController.new);

final canWriteProvider = Provider<bool>((ref) {
  final role = ref.watch(authControllerProvider).value?.user.role;
  return role == UserRole.admin || role == UserRole.seller;
});

final currentSessionProvider = Provider<AuthSession?>((ref) {
  return ref.watch(authControllerProvider).value;
});
