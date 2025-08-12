import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cashflow/core/localization/locale_service.dart';
import 'package:cashflow/core/localization/locale_event.dart';

@singleton
class LocaleBloc extends Bloc<LocaleEvent, Locale> {
  final LocaleService _localeService;
  
  LocaleBloc(this._localeService) : super(const Locale('en')) {
    on<LocaleLoaded>(_onLoaded);
    on<LocaleChanged>(_onChanged);
  }
  
  Locale get currentLocale => state;
  
  static final List<Locale> supportedLocales = [
    const Locale('en'),
    const Locale('id'),
    const Locale('ms'),
  ];
  
  Future<void> _onLoaded(
    LocaleLoaded event,
    Emitter<Locale> emit,
  ) async {
    final savedLocale = await _localeService.getSavedLocale();
    
    if (savedLocale != null && supportedLocales.contains(savedLocale)) {
      emit(savedLocale);
    }
  }
  
  Future<void> _onChanged(
    LocaleChanged event,
    Emitter<Locale> emit,
  ) async {
    if (supportedLocales.contains(event.locale) && state != event.locale) {
      await _localeService.saveLocale(event.locale);
      emit(event.locale);
    }
  }
}