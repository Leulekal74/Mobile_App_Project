import '../../../../core/network/api_client.dart';
import '../models/app_user_model.dart';

class AuthRemoteDataSource {
  AuthRemoteDataSource(this._apiClient);

  final ApiClient _apiClient;

  Future<AuthSessionModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.post(
      '/auth/login',
      body: {
        'email': email,
        'password': password,
      },
    );

    return AuthSessionModel.fromJson(response);
  }

  Future<AuthSessionModel> signup({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    final response = await _apiClient.post(
      '/auth/signup',
      body: {
        'name': name,
        'email': email,
        'password': password,
        'role': role,
      },
    );

    return AuthSessionModel.fromJson(response);
  }
}
