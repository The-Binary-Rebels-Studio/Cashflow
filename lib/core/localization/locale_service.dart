import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class LocaleService {
  Future<Locale?> getSavedLocale();
  Future<void> saveLocale(Locale locale);
}

@Injectable(as: LocaleService)
class LocaleServiceImpl implements LocaleService {
  static const String _localeKey = 'selected_locale';
  final SharedPreferences _prefs;

  LocaleServiceImpl(this._prefs);

  @override
  Future<Locale?> getSavedLocale() async {
    final savedLocale = _prefs.getString(_localeKey);
    if (savedLocale != null) {
      return Locale(savedLocale);
    }
    return null;
  }

  @override
  Future<void> saveLocale(Locale locale) async {
    await _prefs.setString(_localeKey, locale.languageCode);
  }
}