import '../../../../core/network/api_client.dart';
import '../../../auth/domain/entities/auth_session.dart';
import '../models/artisan_model.dart';
import '../models/dye_model.dart';
import '../models/pattern_model.dart';

class ArchiveRemoteDataSource {
  ArchiveRemoteDataSource(this._apiClient);

  final ApiClient _apiClient;

  Future<List<PatternModel>> getPatterns(AuthSession session) async {
    final response = await _apiClient.getList('/patterns', token: session.token);
    return response
        .map((entry) => PatternModel.fromJson(entry as Map<String, dynamic>))
        .toList();
  }

  Future<List<DyeModel>> getDyes(AuthSession session) async {
    final response = await _apiClient.getList('/dyes', token: session.token);
    return response
        .map((entry) => DyeModel.fromJson(entry as Map<String, dynamic>))
        .toList();
  }

  Future<List<ArtisanModel>> getArtisans(AuthSession session) async {
    final response = await _apiClient.getList('/artisans', token: session.token);
    return response
        .map((entry) => ArtisanModel.fromJson(entry as Map<String, dynamic>))
        .toList();
  }

  Future<PatternModel> createPattern(AuthSession session, Map<String, dynamic> body) async {
    final response =
        await _apiClient.post('/patterns', body: body, token: session.token);
    return PatternModel.fromJson(response);
  }

  Future<PatternModel> updatePattern(
    AuthSession session,
    String id,
    Map<String, dynamic> body,
  ) async {
    final response =
        await _apiClient.put('/patterns/$id', body: body, token: session.token);
    return PatternModel.fromJson(response);
  }

  Future<void> deletePattern(AuthSession session, String id) {
    return _apiClient.delete('/patterns/$id', token: session.token);
  }

  Future<DyeModel> createDye(AuthSession session, Map<String, dynamic> body) async {
    final response = await _apiClient.post('/dyes', body: body, token: session.token);
    return DyeModel.fromJson(response);
  }

  Future<DyeModel> updateDye(
    AuthSession session,
    String id,
    Map<String, dynamic> body,
  ) async {
    final response = await _apiClient.put('/dyes/$id', body: body, token: session.token);
    return DyeModel.fromJson(response);
  }

  Future<void> deleteDye(AuthSession session, String id) {
    return _apiClient.delete('/dyes/$id', token: session.token);
  }

  Future<ArtisanModel> createArtisan(AuthSession session, Map<String, dynamic> body) async {
    final response =
        await _apiClient.post('/artisans', body: body, token: session.token);
    return ArtisanModel.fromJson(response);
  }

  Future<ArtisanModel> updateArtisan(
    AuthSession session,
    String id,
    Map<String, dynamic> body,
  ) async {
    final response =
        await _apiClient.put('/artisans/$id', body: body, token: session.token);
    return ArtisanModel.fromJson(response);
  }

  Future<void> deleteArtisan(AuthSession session, String id) {
    return _apiClient.delete('/artisans/$id', token: session.token);
  }
}
