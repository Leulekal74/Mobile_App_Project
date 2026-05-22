import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';

import '../../domain/entities/auth_session.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';

/// Concrete implementation of [AuthRepository] using remote and local data sources.
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  static const Duration _cacheDuration = Duration(minutes: 5);
  static const Duration _connectivityTimeout = Duration(seconds: 5);
  static const int _maxRetryAttempts = 2;

  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  AuthSession? _cachedSession;
  DateTime? _cachedSessionExpiry;

  Future<void> _ensureNetworkConnection() async {
    try {
      final result = await InternetAddress.lookup('example.com').timeout(_connectivityTimeout);
      if (result.isEmpty || result.first.rawAddress.isEmpty) {
        throw NetworkException('Unable to establish a network connection.');
      }
    } on SocketException catch (error) {
      throw NetworkException('Network connectivity error: ${error.message}');
    } on TimeoutException catch (_) {
      throw NetworkException('Network connectivity check timed out.');
    }
  }

  Future<T> _retry<T>(Future<T> Function() action) async {
    Object? lastError;
    for (var attempt = 1; attempt <= _maxRetryAttempts; attempt++) {
      try {
        return await action();
      } catch (error, stackTrace) {
        lastError = error;
        debugPrint('AuthRepositoryImpl retry attempt $attempt failed: $error');
        debugPrint('$stackTrace');
        if (attempt == _maxRetryAttempts) {
          rethrow;
        }
      }
    }
    throw lastError ?? AuthException('Retry failed without an error.');
  }

  void _cacheSession(AuthSession session) {
    _cachedSession = session;
    _cachedSessionExpiry = DateTime.now().add(_cacheDuration);
    debugPrint('AuthRepositoryImpl cached session until $_cachedSessionExpiry');
  }

  void _invalidateCache() {
    _cachedSession = null;
    _cachedSessionExpiry = null;
  }

  Map<String, dynamic> _normalizeResponse(Map<String, dynamic> response) {
    if (response['data'] is Map<String, dynamic>) {
      return response['data'] as Map<String, dynamic>;
    }
    return response;
  }

  @override
  Future<AuthSession> login(String email, String password) async {
    if (email.trim().isEmpty || password.isEmpty) {
      throw AuthException('Email and password are required.');
    }

    await _ensureNetworkConnection();

    try {
      final rawResponse = await _retry<Map<String, dynamic>>(
        () => _remoteDataSource.login(email.trim(), password),
      );

      final normalized = _normalizeResponse(rawResponse);
      final session = AuthSession.fromJson(normalized);

      await _localDataSource.saveSession(session);
      await _localDataSource.saveToken(session.token);
      _cacheSession(session);

      return session;
    } catch (error) {
      debugPrint('AuthRepositoryImpl login failed: $error');
      rethrow;
    }
  }

  @override
  Future<AuthSession> signup({
    required String email,
    required String password,
    required String name,
    required UserRole role,
  }) async {
    if (email.trim().isEmpty || password.isEmpty || name.trim().isEmpty) {
      throw AuthException('Email, name, and password are required.');
    }

    await _ensureNetworkConnection();

    try {
      final rawResponse = await _remoteDataSource.signup(
        email: email.trim(),
        password: password,
        name: name.trim(),
        role: role.name,
      );

      final normalized = _normalizeResponse(rawResponse);
      final session = AuthSession.fromJson(normalized);

      await _localDataSource.saveSession(session);
      await _localDataSource.saveToken(session.token);
      _cacheSession(session);

      return session;
    } catch (error) {
      debugPrint('AuthRepositoryImpl signup failed: $error');
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _localDataSource.deleteSession();
      await _localDataSource.deleteToken();
      _invalidateCache();
      debugPrint('AuthRepositoryImpl logout completed locally.');
    } catch (error) {
      debugPrint('AuthRepositoryImpl logout failed: $error');
      rethrow;
    }
  }

  @override
  Future<AuthSession?> getCurrentSession() async {
    if (_cachedSession != null && _cachedSessionExpiry != null) {
      if (DateTime.now().isBefore(_cachedSessionExpiry!)) {
        if (!_cachedSession!.isExpired()) {
          return _cachedSession;
        }
      }
    }

    try {
      final session = await _localDataSource.getSession();
      if (session == null) {
        _invalidateCache();
        return null;
      }

      if (session.isExpired()) {
        debugPrint('AuthRepositoryImpl found expired session and will clear it.');
        await _localDataSource.deleteSession();
        await _localDataSource.deleteToken();
        _invalidateCache();
        return null;
      }

      _cacheSession(session);
      return session;
    } catch (error) {
      debugPrint('AuthRepositoryImpl getCurrentSession error: $error');
      return null;
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    if (email.trim().isEmpty) {
      throw AuthException('Email is required for password recovery.');
    }

    await _ensureNetworkConnection();

    try {
      await _remoteDataSource.forgotPassword(email.trim());
    } catch (error) {
      debugPrint('AuthRepositoryImpl forgotPassword failed: $error');
      rethrow;
    }
  }

  @override
  Future<void> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    if (token.trim().isEmpty || newPassword.isEmpty) {
      throw AuthException('Reset token and new password are required.');
    }

    await _ensureNetworkConnection();

    try {
      await _remoteDataSource.resetPassword(
        token: token.trim(),
        newPassword: newPassword,
      );
    } catch (error) {
      debugPrint('AuthRepositoryImpl resetPassword failed: $error');
      rethrow;
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    try {
      final session = await getCurrentSession();
      return session != null;
    } catch (error) {
      debugPrint('AuthRepositoryImpl isLoggedIn check failed: $error');
      return false;
    }
  }
}
