import '../entities/artisan.dart';
import '../entities/dye.dart';
import '../entities/pattern.dart';

abstract class ArchiveRepository {
  Future<List<PatternRecord>> getPatterns({bool forceRefresh = false});
  Future<List<DyeRecord>> getDyes({bool forceRefresh = false});
  Future<List<ArtisanRecord>> getArtisans({bool forceRefresh = false});

  Future<PatternRecord> createPattern(Map<String, dynamic> payload);
  Future<PatternRecord> updatePattern(String id, Map<String, dynamic> payload);
  Future<void> deletePattern(String id);

  Future<DyeRecord> createDye(Map<String, dynamic> payload);
  Future<DyeRecord> updateDye(String id, Map<String, dynamic> payload);
  Future<void> deleteDye(String id);

  Future<ArtisanRecord> createArtisan(Map<String, dynamic> payload);
  Future<ArtisanRecord> updateArtisan(String id, Map<String, dynamic> payload);
  Future<void> deleteArtisan(String id);
}
    