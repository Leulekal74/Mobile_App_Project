import '../../domain/entities/app_user.dart';
import '../../domain/entities/auth_session.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthLocalDataSource localDataSource,
    required AuthRemoteDataSource remoteDataSource,
  })  : _localDataSource = localDataSource,
        _remoteDataSource = remoteDataSource;

  final AuthLocalDataSource _localDataSource;
  final AuthRemoteDataSource _remoteDataSource;

  @override
  Future<AuthSession> login({
    required String email,
    required String password,
  }) async {
    await _localDataSource.clearArchiveCaches();
    final session = await _remoteDataSource.login(
      email: email,
      password: password,
    );
    await _localDataSource.persistSession(session);
    return session;
  }

  @override
  Future<void> logout() async {
    await _localDataSource.clearArchiveCaches();
    await _localDataSource.clearSession();
  }

  @override
  Future<AuthSession?> restoreSession() {
    return _localDataSource.restoreSession();
  }

  @override
  Future<AuthSession> signup({
    required String name,
    required String email,
    required String password,
    required UserRole role,
  }) async {
    await _localDataSource.clearArchiveCaches();
    final session = await _remoteDataSource.signup(
      name: name,
      email: email,
      password: password,
      role: role.value,
    );
    await _localDataSource.persistSession(session);
    return session;
  }
}
