import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:cashflow/features/localization/domain/repositories/localization_repository.dart';
import 'package:cashflow/core/localization/locale_bloc.dart';
import 'package:cashflow/core/localization/locale_event.dart';

@injectable
class ChangeLocale {
  final LocalizationRepository _repository;
  final LocaleBloc _localeBloc;

  ChangeLocale(this._repository, this._localeBloc);

  Future<void> call(Locale locale) async {
    
    await _repository.setLocale(locale);
    
    
    _localeBloc.add(LocaleChanged(locale: locale));
  }
}