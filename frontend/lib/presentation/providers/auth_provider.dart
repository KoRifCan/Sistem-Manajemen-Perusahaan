import 'dart:async';
import 'package:flutter/material.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _repository = AuthRepository();
  UserModel? _user;
  bool _isLoading = false;
  bool _isInitialized = false;
  String? _error;
  StreamSubscription? _authSub;
  StreamSubscription? _userSub;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  bool get isInitialized => _isInitialized;
  bool get isAuthenticated => _user != null;
  String? get error => _error;

  AuthProvider() {
    _authSub = _repository.authStateChanges.listen((firebaseUser) {
      if (firebaseUser == null) {
        _userSub?.cancel();
        _user = null;
      } else {
        _loadUser();
      }
      _isInitialized = true;
      notifyListeners();
    }, onError: (e) {
      _isInitialized = true;
      notifyListeners();
    });
  }

  void _loadUser() {
    _userSub?.cancel();
    _userSub = _repository.getCurrentUserData().listen((user) {
      _user = user;
      notifyListeners();
    }, onError: (e) {
      _user = null;
      notifyListeners();
    });
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
    _userSub?.cancel();
    await _repository.logout();
    _user = null;
    notifyListeners();
  }

  Future<void> changePassword(String currentPassword, String newPassword) async {
    try {
      await _repository.changePassword(currentPassword, newPassword);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _repository.resetPassword(email);
    } catch (e) {
      rethrow;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _authSub?.cancel();
    _userSub?.cancel();
    super.dispose();
  }
}
