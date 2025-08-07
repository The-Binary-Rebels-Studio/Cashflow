import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:sqflite/sqflite.dart';

abstract class LocaleService {
  Future<Locale?> getSavedLocale();
  Future<void> saveLocale(Locale locale);
}

@Injectable(as: LocaleService)
class LocaleServiceImpl implements LocaleService {
  final Database _database;

  LocaleServiceImpl(this._database);

  @override
  Future<Locale?> getSavedLocale() async {
    final result = await _database.query(
      'app_settings',
      columns: ['locale'],
      limit: 1,
    );
    
    if (result.isNotEmpty && result.first['locale'] != null) {
      return Locale(result.first['locale'] as String);
    }
    return null;
  }

  @override
  Future<void> saveLocale(Locale locale) async {
    final existing = await _database.query('app_settings', limit: 1);
    
    if (existing.isNotEmpty) {
      await _database.update(
        'app_settings',
        {'locale': locale.languageCode},
        where: 'id = ?',
        whereArgs: [existing.first['id']],
      );
    } else {
      await _database.insert(
        'app_settings',
        {'locale': locale.languageCode},
      );
    }
  }
}