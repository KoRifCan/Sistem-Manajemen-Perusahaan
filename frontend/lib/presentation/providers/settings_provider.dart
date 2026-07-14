import 'package:flutter/material.dart';

class SettingsProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  Locale _locale = const Locale('id', 'ID');
  bool _notificationsEnabled = true;
  bool _biometricEnabled = false;

  ThemeMode get themeMode => _themeMode;
  Locale get locale => _locale;
  bool get notificationsEnabled => _notificationsEnabled;
  bool get biometricEnabled => _biometricEnabled;
  bool get isDark => _themeMode == ThemeMode.dark;

  void toggleTheme() {
    _themeMode = isDark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  void setLocale(Locale locale) {
    _locale = locale;
    notifyListeners();
  }

  void toggleNotifications() {
    _notificationsEnabled = !_notificationsEnabled;
    notifyListeners();
  }

  void toggleBiometric() {
    _biometricEnabled = !_biometricEnabled;
    notifyListeners();
  }
}
