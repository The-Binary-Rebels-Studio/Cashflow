import 'package:flutter/material.dart';

class AppLocale {
  final Locale locale;
  final String displayName;
  
  const AppLocale({
    required this.locale,
    required this.displayName,
  });
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppLocale &&
          runtimeType == other.runtimeType &&
          locale == other.locale &&
          displayName == other.displayName;

  @override
  int get hashCode => locale.hashCode ^ displayName.hashCode;

  @override
  String toString() => 'AppLocale(locale: $locale, displayName: $displayName)';
}