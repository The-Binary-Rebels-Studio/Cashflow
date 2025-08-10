import 'package:flutter/material.dart';
import 'package:cashflow/features/localization/domain/entities/app_locale.dart';

abstract class LocalizationRepository {
  Future<Locale?> getCurrentLocale();
  Future<void> setLocale(Locale locale);
  List<AppLocale> getSupportedLocales();
}