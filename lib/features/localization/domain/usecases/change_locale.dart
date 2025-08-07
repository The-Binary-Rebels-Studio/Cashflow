import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import '../repositories/localization_repository.dart';
import '../../../../core/localization/locale_manager.dart';

@injectable
class ChangeLocale {
  final LocalizationRepository _repository;
  final LocaleManager _localeManager;

  ChangeLocale(this._repository, this._localeManager);

  Future<void> call(Locale locale) async {
    // Save to local storage via repository
    await _repository.setLocale(locale);
    
    // Update app state immediately via LocaleManager
    await _localeManager.changeLocale(locale);
  }
}