import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants/app_constants.dart';

class ApiClient {
  ApiClient(this._client);

  final http.Client _client;

  Uri _uri(String path) => Uri.parse('${AppConstants.apiBaseUrl}$path');

  Future<Map<String, dynamic>> getObject(
    String path, {
    String? token,
  }) async {
    final response = await _client.get(
      _uri(path),
      headers: _headers(token),
    );
    return _decodeObject(response);
  }

  Future<List<dynamic>> getList(
    String path, {
    String? token,
  }) async {
    final response = await _client.get(
      _uri(path),
      headers: _headers(token),
    );
    return _decodeList(response);
  }

  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? body,
    String? token,
  }) async {
    final response = await _client.post(
      _uri(path),
      headers: _headers(token),
      body: jsonEncode(body ?? {}),
    );
    return _decodeObject(response);
  }

  Future<Map<String, dynamic>> put(
    String path, {
    required Map<String, dynamic> body,
    String? token,
  }) async {
    final response = await _client.put(
      _uri(path),
      headers: _headers(token),
      body: jsonEncode(body),
    );
    return _decodeObject(response);
  }

  Future<void> delete(
    String path, {
    String? token,
  }) async {
    final response = await _client.delete(
      _uri(path),
      headers: _headers(token),
    );
    if (response.statusCode >= 400) {
      throw Exception(_extractError(response));
    }
  }

  Map<String, String> _headers(String? token) {
    return {
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  Map<String, dynamic> _decodeObject(http.Response response) {
    final payload = response.body.isEmpty
        ? <String, dynamic>{}
        : jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode >= 400) {
      throw Exception(payload['message'] ?? 'Request failed.');
    }
    return payload;
  }

  List<dynamic> _decodeList(http.Response response) {
    final payload =
        response.body.isEmpty ? <dynamic>[] : jsonDecode(response.body) as List<dynamic>;
    if (response.statusCode >= 400) {
      throw Exception(_extractError(response));
    }
    return payload;
  }

  String _extractError(http.Response response) {
    if (response.body.isEmpty) return 'Request failed.';
    final decoded = jsonDecode(response.body);
    if (decoded is Map<String, dynamic>) {
      return decoded['message']?.toString() ?? 'Request failed.';
    }
    return 'Request failed.';
  }
}
