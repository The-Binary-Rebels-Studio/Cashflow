import 'package:flutter/material.dart';

class LocaleModel {
  final Locale locale;
  final String name;
  final String nativeName;
  final String flag;

  const LocaleModel({
    required this.locale,
    required this.name,
    required this.nativeName,
    required this.flag,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocaleModel &&
          runtimeType == other.runtimeType &&
          locale == other.locale;

  @override
  int get hashCode => locale.hashCode;
}

class LocaleData {
  static const List<LocaleModel> supportedLocales = [
    LocaleModel(
      locale: Locale('en'),
      name: 'English',
      nativeName: 'English',
      flag: '🇺🇸',
    ),
    LocaleModel(
      locale: Locale('id'),
      name: 'Indonesian',
      nativeName: 'Bahasa Indonesia',
      flag: '🇮🇩',
    ),
    LocaleModel(
      locale: Locale('ms'),
      name: 'Malay',
      nativeName: 'Bahasa Melayu',
      flag: '🇲🇾',
    ),
  ];

  static LocaleModel? getLocaleByCode(String languageCode) {
    try {
      return supportedLocales.firstWhere(
        (localeModel) => localeModel.locale.languageCode == languageCode,
      );
    } catch (e) {
      return null;
    }
  }
}