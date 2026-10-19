import 'package:shared_preferences/shared_preferences.dart';
import 'package:story_app/domain/entities/user_session.dart';

/// Stores only the session (user id, name, token). The password is never saved.
class AuthLocalDataSource {
  const AuthLocalDataSource(this._prefs);

  final SharedPreferences _prefs;

  static const String _tokenKey = 'session_token';
  static const String _userIdKey = 'session_user_id';
  static const String _nameKey = 'session_name';

  UserSession? getSession() {
    final token = _prefs.getString(_tokenKey);
    if (token == null) return null;
    return UserSession(
      userId: _prefs.getString(_userIdKey) ?? '',
      name: _prefs.getString(_nameKey) ?? '',
      token: token,
    );
  }

  Future<void> saveSession(UserSession session) async {
    await _prefs.setString(_tokenKey, session.token);
    await _prefs.setString(_userIdKey, session.userId);
    await _prefs.setString(_nameKey, session.name);
  }

  Future<void> clearSession() async {
    await _prefs.remove(_tokenKey);
    await _prefs.remove(_userIdKey);
    await _prefs.remove(_nameKey);
  }
}
