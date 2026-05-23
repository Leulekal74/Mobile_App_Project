import '../../../auth/application/auth_controller.dart';
import '../../../auth/domain/entities/auth_session.dart';
import '../../domain/entities/artisan.dart';
import '../../domain/entities/dye.dart';
import '../../domain/entities/pattern.dart';
import '../../domain/repositories/archive_repository.dart';
import '../datasources/archive_local_data_source.dart';
import '../datasources/archive_remote_data_source.dart';
import '../models/artisan_model.dart';
import '../models/dye_model.dart';
import '../models/pattern_model.dart';

class ArchiveRepositoryImpl implements ArchiveRepository {
  ArchiveRepositoryImpl({
    required ArchiveLocalDataSource localDataSource,
    required ArchiveRemoteDataSource remoteDataSource,
    required AuthSession Function() sessionReader,
  })  : _localDataSource = localDataSource,
        _remoteDataSource = remoteDataSource,
        _sessionReader = sessionReader;

  final ArchiveLocalDataSource _localDataSource;
  final ArchiveRemoteDataSource _remoteDataSource;
  final AuthSession Function() _sessionReader;

  @override
  Future<List<PatternRecord>> getPatterns({bool forceRefresh = false}) async {
    if (!forceRefresh) {
      final cached = await _localDataSource.getPatterns();
      if (cached.isNotEmpty) return cached;
    }
    final remote = await _remoteDataSource.getPatterns(_sessionReader());
    await _localDataSource.cachePatterns(remote);
    return remote;
  }

  @override
  Future<List<DyeRecord>> getDyes({bool forceRefresh = false}) async {
    if (!forceRefresh) {
      final cached = await _localDataSource.getDyes();
      if (cached.isNotEmpty) return cached;
    }
    final remote = await _remoteDataSource.getDyes(_sessionReader());
    await _localDataSource.cacheDyes(remote);
    return remote;
  }

  @override
  Future<List<ArtisanRecord>> getArtisans({bool forceRefresh = false}) async {
    if (!forceRefresh) {
      final cached = await _localDataSource.getArtisans();
      if (cached.isNotEmpty) return cached;
    }
    final remote = await _remoteDataSource.getArtisans(_sessionReader());
    await _localDataSource.cacheArtisans(remote);
    return remote;
  }

  @override
  Future<PatternRecord> createPattern(Map<String, dynamic> payload) async {
    final created = await _remoteDataSource.createPattern(_sessionReader(), payload);
    await _refreshPatterns();
    return created;
  }

  @override
  Future<void> deletePattern(String id) async {
    await _remoteDataSource.deletePattern(_sessionReader(), id);
    await _refreshPatterns();
  }

  @override
  Future<PatternRecord> updatePattern(String id, Map<String, dynamic> payload) async {
    final updated = await _remoteDataSource.updatePattern(_sessionReader(), id, payload);
    await _refreshPatterns();
    return updated;
  }

  @override
  Future<DyeRecord> createDye(Map<String, dynamic> payload) async {
    final created = await _remoteDataSource.createDye(_sessionReader(), payload);
    await _refreshDyes();
    return created;
  }

  @override
  Future<void> deleteDye(String id) async {
    await _remoteDataSource.deleteDye(_sessionReader(), id);
    await _refreshDyes();
  }

  @override
  Future<DyeRecord> updateDye(String id, Map<String, dynamic> payload) async {
    final updated = await _remoteDataSource.updateDye(_sessionReader(), id, payload);
    await _refreshDyes();
    return updated;
  }

  @override
  Future<ArtisanRecord> createArtisan(Map<String, dynamic> payload) async {
    final created = await _remoteDataSource.createArtisan(_sessionReader(), payload);
    await _refreshArtisans();
    return created;
  }

  @override
  Future<void> deleteArtisan(String id) async {
    await _remoteDataSource.deleteArtisan(_sessionReader(), id);
    await _refreshArtisans();
  }

  @override
  Future<ArtisanRecord> updateArtisan(String id, Map<String, dynamic> payload) async {
    final updated = await _remoteDataSource.updateArtisan(_sessionReader(), id, payload);
    await _refreshArtisans();
    return updated;
  }

  Future<void> _refreshPatterns() async {
    final remote = await _remoteDataSource.getPatterns(_sessionReader());
    await _localDataSource.cachePatterns(remote.cast<PatternModel>());
  }

  Future<void> _refreshDyes() async {
    final remote = await _remoteDataSource.getDyes(_sessionReader());
    await _localDataSource.cacheDyes(remote.cast<DyeModel>());
  }

  Future<void> _refreshArtisans() async {
    final remote = await _remoteDataSource.getArtisans(_sessionReader());
    await _localDataSource.cacheArtisans(remote.cast<ArtisanModel>());
  }
}
