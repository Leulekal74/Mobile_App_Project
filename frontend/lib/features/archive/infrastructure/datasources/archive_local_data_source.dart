import '../../../../core/database/app_database.dart';
import '../models/artisan_model.dart';
import '../models/dye_model.dart';
import '../models/pattern_model.dart';

class ArchiveLocalDataSource {
  ArchiveLocalDataSource(this._database);

  final AppDatabase _database;

  Future<List<PatternModel>> getPatterns() async {
    final rows = await _database.readCachedRows('patterns');
    return rows.map(PatternModel.fromJson).toList();
  }

  Future<void> cachePatterns(List<PatternModel> patterns) async {
    await _database.cacheRows(
      'patterns',
      patterns.map((entry) => entry.toJson()).toList(),
    );
  }

  Future<List<DyeModel>> getDyes() async {
    final rows = await _database.readCachedRows('dyes');
    return rows.map(DyeModel.fromJson).toList();
  }

  Future<void> cacheDyes(List<DyeModel> dyes) async {
    await _database.cacheRows(
      'dyes',
      dyes.map((entry) => entry.toJson()).toList(),
    );
  }

  Future<List<ArtisanModel>> getArtisans() async {
    final rows = await _database.readCachedRows('artisans');
    return rows.map(ArtisanModel.fromJson).toList();
  }

  Future<void> cacheArtisans(List<ArtisanModel> artisans) async {
    await _database.cacheRows(
      'artisans',
      artisans.map((entry) => entry.toJson()).toList(),
    );
  }
}
