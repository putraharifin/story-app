import 'package:story_app/core/network/api_client.dart';
import 'package:story_app/data/models/user_session_model.dart';

class AuthRemoteDataSource {
  const AuthRemoteDataSource(this._client);

  final ApiClient _client;

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    await _client.post(
      '/register',
      body: {'name': name, 'email': email, 'password': password},
    );
  }

  Future<UserSessionModel> login({
    required String email,
    required String password,
  }) async {
    final body = await _client.post(
      '/login',
      body: {'email': email, 'password': password},
    );
    return UserSessionModel.fromJson(
      body['loginResult'] as Map<String, dynamic>,
    );
  }
}
