import '../../../../core/database/app_database.dart';
import '../models/app_user_model.dart';

class AuthLocalDataSource {
  AuthLocalDataSource(this._database);

  final AppDatabase _database;

  Future<AuthSessionModel?> restoreSession() async {
    final cached = await _database.readSession();
    if (cached == null) return null;
    return AuthSessionModel(
      token: cached['token'] as String,
      user: AppUserModel.fromJson(cached['user'] as Map<String, dynamic>),
    );
  }

  Future<void> persistSession(AuthSessionModel session) async {
    await _database.upsertSession(
      token: session.token,
      userJson: (session.user as AppUserModel).toJson(),
    );
  }

  Future<void> clearSession() async {
    await _database.clearSession();
  }

  Future<void> clearArchiveCaches() async {
    await _database.clearArchiveCaches();
  }
}
