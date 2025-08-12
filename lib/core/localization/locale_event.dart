import 'package:flutter/material.dart';

abstract class LocaleEvent {
  const LocaleEvent();
}

class LocaleLoaded extends LocaleEvent {
  const LocaleLoaded();
}

class LocaleChanged extends LocaleEvent {
  final Locale locale;

  const LocaleChanged({
    required this.locale,
  });
}