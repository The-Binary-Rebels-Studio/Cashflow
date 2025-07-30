import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'locale_service.dart';

@singleton
class LocaleManager extends ChangeNotifier {
  final LocaleService _localeService;
  
  Locale _currentLocale = const Locale('en');
  
  LocaleManager(this._localeService);
  
  Locale get currentLocale => _currentLocale;
  
  static final List<Locale> supportedLocales = [
    const Locale('en'),
    const Locale('id'),
    const Locale('ms'),
  ];
  
  Future<void> loadSavedLocale() async {
    final savedLocale = await _localeService.getSavedLocale();
    
    if (savedLocale != null && supportedLocales.contains(savedLocale)) {
      _currentLocale = savedLocale;
      notifyListeners();
    }
  }
  
  Future<void> changeLocale(Locale locale) async {
    if (supportedLocales.contains(locale) && _currentLocale != locale) {
      _currentLocale = locale;
      await _localeService.saveLocale(locale);
      notifyListeners();
    }
  }
}