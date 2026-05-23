import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class AppDatabase {
  AppDatabase();

  Database? _database;
  SharedPreferences? _preferences;

  Future<Database> instance() async {
    if (_database != null) return _database!;

    if (kIsWeb) {
      throw UnsupportedError('SQLite instance is not available on web.');
    }

    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    final appDir = await getApplicationDocumentsDirectory();
    final dbPath = p.join(appDir.path, 'tibeb_archive.db');

    _database = await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE auth_session (
            id INTEGER PRIMARY KEY,
            token TEXT NOT NULL,
            user_json TEXT NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE patterns (
            id TEXT PRIMARY KEY,
            data TEXT NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE dyes (
            id TEXT PRIMARY KEY,
            data TEXT NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE artisans (
            id TEXT PRIMARY KEY,
            data TEXT NOT NULL
          )
        ''');
      },
    );

    return _database!;
  }

  Future<SharedPreferences> _prefs() async {
    if (_preferences != null) return _preferences!;
    _preferences = await SharedPreferences.getInstance();
    return _preferences!;
  }

  Future<void> cacheRows(String table, List<Map<String, dynamic>> rows) async {
    if (kIsWeb) {
      final prefs = await _prefs();
      await prefs.setString('cache_$table', jsonEncode(rows));
      return;
    }

    final db = await instance();
    final batch = db.batch();
    batch.delete(table);
    for (final row in rows) {
      batch.insert(
        table,
        {
          'id': row['id'],
          'data': jsonEncode(row),
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  Future<List<Map<String, dynamic>>> readCachedRows(String table) async {
    if (kIsWeb) {
      final prefs = await _prefs();
      final raw = prefs.getString('cache_$table');
      if (raw == null || raw.isEmpty) return [];
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded.cast<Map<String, dynamic>>();
    }

    final db = await instance();
    final rows = await db.query(table, orderBy: 'id ASC');
    return rows
        .map((entry) => jsonDecode(entry['data'] as String) as Map<String, dynamic>)
        .toList();
  }

  Future<void> clearCachedRows(String table) async {
    if (kIsWeb) {
      final prefs = await _prefs();
      await prefs.remove('cache_$table');
      return;
    }

    final db = await instance();
    await db.delete(table);
  }

  Future<void> clearArchiveCaches() async {
    await clearCachedRows('patterns');
    await clearCachedRows('dyes');
    await clearCachedRows('artisans');
  }

  Future<void> upsertSession({
    required String token,
    required Map<String, dynamic> userJson,
  }) async {
    if (kIsWeb) {
      final prefs = await _prefs();
      await prefs.setString(
        'auth_session',
        jsonEncode({
          'token': token,
          'user': userJson,
        }),
      );
      return;
    }

    final db = await instance();
    await db.insert(
      'auth_session',
      {
        'id': 1,
        'token': token,
        'user_json': jsonEncode(userJson),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, dynamic>?> readSession() async {
    if (kIsWeb) {
      final prefs = await _prefs();
      final raw = prefs.getString('auth_session');
      if (raw == null || raw.isEmpty) return null;
      return jsonDecode(raw) as Map<String, dynamic>;
    }

    final db = await instance();
    final rows = await db.query('auth_session', where: 'id = 1');
    if (rows.isEmpty) return null;
    return {
      'token': rows.first['token'],
      'user': jsonDecode(rows.first['user_json'] as String),
    };
  }

  Future<void> clearSession() async {
    if (kIsWeb) {
      final prefs = await _prefs();
      await prefs.remove('auth_session');
      return;
    }

    final db = await instance();
    await db.delete('auth_session');
  }
}
