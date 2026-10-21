import 'package:flutter/foundation.dart';
import 'package:story_app/core/error/app_exception.dart';
import 'package:story_app/domain/entities/user_session.dart';
import 'package:story_app/domain/repositories/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider(AuthRepository repository)
    : _repository = repository,
      _session = repository.getSession();

  final AuthRepository _repository;

  UserSession? _session;
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoggedIn => _session != null;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> login(String email, String password) async {
    _start();
    try {
      _session = await _repository.login(email: email, password: password);
      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      return false;
    } on Exception {
      return false;
    } finally {
      _finish();
    }
  }

  Future<bool> register(String name, String email, String password) async {
    _start();
    try {
      await _repository.register(name: name, email: email, password: password);
      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      return false;
    } on Exception {
      return false;
    } finally {
      _finish();
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    _session = null;
    notifyListeners();
  }

  void _start() {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
  }

  void _finish() {
    _isLoading = false;
    notifyListeners();
  }
}
