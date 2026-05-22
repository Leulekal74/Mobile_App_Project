import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// Data source responsible for remote authentication API calls.
class AuthRemoteDataSource {
  AuthRemoteDataSource({http.Client? httpClient}) : _httpClient = httpClient ?? http.Client();

  static const String baseUrl = 'http://localhost:3000/api/auth';
  static const Duration _timeout = Duration(seconds: 30);

  final http.Client _httpClient;

  Map<String, String> _headers({String? authToken}) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };
    if (authToken != null && authToken.isNotEmpty) {
      headers['Authorization'] = 'Bearer $authToken';
    }
    return headers;
  }

  Future<Map<String, dynamic>> login(String email, String password, {String? authToken}) async {
    final uri = Uri.parse('$baseUrl/login');
    final body = jsonEncode({'email': email, 'password': password});

    if (kDebugMode) {
      debugPrint('AuthRemoteDataSource.login POST $uri');
      debugPrint('Request body: $body');
    }

    final response = await _httpClient
        .post(uri, headers: _headers(authToken: authToken), body: body)
        .timeout(_timeout);

    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> signup({
    required String email,
    required String password,
    required String name,
    required String role,
    String? authToken,
  }) async {
    final uri = Uri.parse('$baseUrl/signup');
    final body = jsonEncode({
      'email': email,
      'password': password,
      'name': name,
      'role': role,
    });

    if (kDebugMode) {
      debugPrint('AuthRemoteDataSource.signup POST $uri');
      debugPrint('Request body: $body');
    }

    final response = await _httpClient
        .post(uri, headers: _headers(authToken: authToken), body: body)
        .timeout(_timeout);

    return _handleResponse(response);
  }

  Future<void> forgotPassword(String email, {String? authToken}) async {
    final uri = Uri.parse('$baseUrl/forgot-password');
    final body = jsonEncode({'email': email});

    if (kDebugMode) {
      debugPrint('AuthRemoteDataSource.forgotPassword POST $uri');
      debugPrint('Request body: $body');
    }

    final response = await _httpClient
        .post(uri, headers: _headers(authToken: authToken), body: body)
        .timeout(_timeout);

    _handleResponse(response, expectBody: false);
  }

  Future<void> resetPassword({
    required String token,
    required String newPassword,
    String? authToken,
  }) async {
    final uri = Uri.parse('$baseUrl/reset-password');
    final body = jsonEncode({'token': token, 'newPassword': newPassword});

    if (kDebugMode) {
      debugPrint('AuthRemoteDataSource.resetPassword POST $uri');
      debugPrint('Request body: $body');
    }

    final response = await _httpClient
        .post(uri, headers: _headers(authToken: authToken), body: body)
        .timeout(_timeout);

    _handleResponse(response, expectBody: false);
  }

  Object? _parseBody(http.Response response) {
    try {
      if (response.body.isEmpty) {
        return null;
      }
      return jsonDecode(response.body);
    } catch (error) {
      throw ServerException('Failed to parse response body: $error');
    }
  }

  Map<String, dynamic> _handleResponse(http.Response response, {bool expectBody = true}) {
    if (kDebugMode) {
      debugPrint('AuthRemoteDataSource response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (!expectBody || response.body.isEmpty) {
        return <String, dynamic>{};
      }
      final body = _parseBody(response);
      if (body is Map<String, dynamic>) {
        return body;
      }
      throw ServerException('Unexpected response format. Expected JSON object.');
    }

    switch (response.statusCode) {
      case 400:
        throw BadRequestException(_extractMessage(response));
      case 401:
        throw UnauthorizedException(_extractMessage(response));
      case 404:
        throw NotFoundException(_extractMessage(response));
      default:
        if (response.statusCode >= 500) {
          throw ServerException(_extractMessage(response));
        }
        throw ServerException('Unexpected status code: ${response.statusCode}');
    }
  }

  String _extractMessage(http.Response response) {
    try {
      final decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic> && decoded['message'] is String) {
        return decoded['message'] as String;
      }
    } catch (_) {
      // Ignore parse error and fallback to generic message.
    }
    return 'HTTP ${response.statusCode}: ${response.reasonPhrase ?? 'Unknown error'}';
  }
}

/// Exception thrown for invalid request data.
class BadRequestException implements Exception {
  final String message;
  BadRequestException([this.message = 'Bad request']);

  @override
  String toString() => 'BadRequestException: $message';
}

/// Exception thrown when authentication is required or failed.
class UnauthorizedException implements Exception {
  final String message;
  UnauthorizedException([this.message = 'Unauthorized']);

  @override
  String toString() => 'UnauthorizedException: $message';
}

/// Exception thrown when an endpoint cannot be found.
class NotFoundException implements Exception {
  final String message;
  NotFoundException([this.message = 'Resource not found']);

  @override
  String toString() => 'NotFoundException: $message';
}

/// Exception thrown for backend/server failures.
class ServerException implements Exception {
  final String message;
  ServerException([this.message = 'Server error occurred']);

  @override
  String toString() => 'ServerException: $message';
}
