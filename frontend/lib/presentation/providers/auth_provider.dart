import 'package:flutter/material.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _repository = AuthRepository();
  UserModel? _user;
  bool _isLoading = false;
  String? _error;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;
  String? get error => _error;

  AuthProvider() {
    _repository.authStateChanges.listen((firebaseUser) {
      if (firebaseUser == null) {
        _user = null;
        notifyListeners();
      } else {
        _loadUser(firebaseUser.uid);
      }
    });
  }

  Future<void> _loadUser(String uid) async {
    try {
      _user = await _repository.getCurrentUserData();
      notifyListeners();
    } catch (_) {
      _user = null;
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _user = await _repository.login(email, password);
      _isLoading = false;
      notifyListeners();
      return _user != null;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String email, String password, String name, {String role = 'staff'}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _user = await _repository.register(email: email, password: password, name: name, role: role);
      _isLoading = false;
      notifyListeners();
      return _user != null;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    _user = null;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
