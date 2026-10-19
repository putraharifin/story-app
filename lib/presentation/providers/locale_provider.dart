import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  LocaleProvider(this._prefs) {
    final code = _prefs.getString(_localeKey);
    if (code != null) _locale = Locale(code);
  }

  static const String _localeKey = 'app_locale';

  final SharedPreferences _prefs;
  Locale? _locale;

  /// Null means "follow the device language".
  Locale? get locale => _locale;

  Future<void> setLocale(Locale locale) async {
    _locale = locale;
    notifyListeners();
    await _prefs.setString(_localeKey, locale.languageCode);
  }
}
