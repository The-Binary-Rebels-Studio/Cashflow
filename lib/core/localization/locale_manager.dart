import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'locale_service.dart';

@singleton
class LocaleManager extends Cubit<Locale> {
  final LocaleService _localeService;
  
  LocaleManager(this._localeService) : super(const Locale('en'));
  
  Locale get currentLocale => state;
  
  static final List<Locale> supportedLocales = [
    const Locale('en'),
    const Locale('id'),
    const Locale('ms'),
  ];
  
  Future<void> loadSavedLocale() async {
    final savedLocale = await _localeService.getSavedLocale();
    
    if (savedLocale != null && supportedLocales.contains(savedLocale)) {
      emit(savedLocale);
    }
  }
  
  Future<void> changeLocale(Locale locale) async {
    if (supportedLocales.contains(locale) && state != locale) {
      await _localeService.saveLocale(locale);
      emit(locale);
    }
  }
}