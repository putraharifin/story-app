import 'package:story_app/data/datasources/auth_local_data_source.dart';
import 'package:story_app/data/datasources/auth_remote_data_source.dart';
import 'package:story_app/domain/entities/user_session.dart';
import 'package:story_app/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({
    required AuthRemoteDataSource remote,
    required AuthLocalDataSource local,
  })  : _remote = remote,
        _local = local;

  final AuthRemoteDataSource _remote;
  final AuthLocalDataSource _local;

  @override
  UserSession? getSession() => _local.getSession();

  @override
  Future<UserSession> login({
    required String email,
    required String password,
  }) async {
    final session = await _remote.login(email: email, password: password);
    await _local.saveSession(session);
    return session;
  }

  @override
  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) {
    return _remote.register(name: name, email: email, password: password);
  }

  @override
  Future<void> logout() => _local.clearSession();
}
