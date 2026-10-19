import 'package:story_app/domain/entities/user_session.dart';

abstract class AuthRepository {
  UserSession? getSession();

  Future<UserSession> login({required String email, required String password});

  Future<void> register({
    required String name,
    required String email,
    required String password,
  });

  Future<void> logout();
}
