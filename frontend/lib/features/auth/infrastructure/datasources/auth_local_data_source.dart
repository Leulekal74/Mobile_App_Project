import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/auth_session.dart';

/// Local data source responsible for persisting authentication session data.
///
/// Uses secure storage for sensitive values and shared preferences for
/// lightweight flags.
class AuthLocalDataSource {
  AuthLocalDataSource({
    FlutterSecureStorage? secureStorage,
    SharedPreferences? sharedPreferences,
  })  : _secureStorage = secureStorage ?? const FlutterSecureStorage(),
        _sharedPreferences = sharedPreferences;

  static const _tokenKey = 'auth_token';
  static const _sessionKey = 'user_session';
  static const _rememberMeKey = 'remember_me';

  final FlutterSecureStorage _secureStorage;
  final SharedPreferences? _sharedPreferences;

  Future<SharedPreferences> get _prefs async {
    return _sharedPreferences ?? await SharedPreferences.getInstance();
  }

  Future<T> _retry<T>(Future<T> Function() action) async {
    try {
      return await action();
    } catch (firstError, stackTrace) {
      debugPrint('AuthLocalDataSource first attempt failed: $firstError');
      try {
        return await action();
      } catch (retryError, retryStack) {
        debugPrint('AuthLocalDataSource retry failed: $retryError');
        debugPrint('StackTrace: $retryStack');
        rethrow;
      }
    }
  }

  /// Saves the full authenticated session to secure storage.
  Future<void> saveSession(AuthSession session) async {
    await _retry(() async {
      final sessionJson = jsonEncode(session.toJson());
      await _secureStorage.write(key: _sessionKey, value: sessionJson);
    });
  }

  /// Retrieves the stored authenticated session, or null if none exists.
  Future<AuthSession?> getSession() async {
    return await _retry(() async {
      final rawJson = await _secureStorage.read(key: _sessionKey);
      if (rawJson == null || rawJson.isEmpty) {
        return null;
      }

      try {
        final Map<String, dynamic> jsonMap = jsonDecode(rawJson) as Map<String, dynamic>;
        return AuthSession.fromJson(jsonMap);
      } catch (error) {
        debugPrint('AuthLocalDataSource failed to parse session JSON: $error');
        return null;
      }
    });
  }

  /// Deletes the stored user session entirely.
  Future<void> deleteSession() async {
    await _retry(() async {
      await _secureStorage.delete(key: _sessionKey);
    });
  }

  /// Saves the authentication token in secure storage.
  Future<void> saveToken(String token) async {
    await _retry(() async {
      await _secureStorage.write(key: _tokenKey, value: token);
    });
  }

  /// Retrieves the saved token, or null when not present.
  Future<String?> getToken() async {
    return await _retry(() async {
      final token = await _secureStorage.read(key: _tokenKey);
      return token?.isNotEmpty == true ? token : null;
    });
  }

  /// Deletes the saved authentication token.
  Future<void> deleteToken() async {
    await _retry(() async {
      await _secureStorage.delete(key: _tokenKey);
    });
  }

  /// Persists the remember-me flag using shared preferences.
  Future<void> setRememberMe(bool value) async {
    await _retry(() async {
      final prefs = await _prefs;
      await prefs.setBool(_rememberMeKey, value);
    });
  }

  /// Returns true when the user chose to be remembered.
  Future<bool> getRememberMe() async {
    return await _retry(() async {
      final prefs = await _prefs;
      return prefs.getBool(_rememberMeKey) ?? false;
    });
  }
}
