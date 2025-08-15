import 'package:injectable/injectable.dart';
import 'package:flutter/material.dart';
import 'package:cashflow/core/database/database_service.dart';

abstract class LocalizationLocalDataSource {
  Future<Locale?> getCurrentLocale();
  Future<void> setLocale(Locale locale);
}

@Injectable(as: LocalizationLocalDataSource)
class LocalizationLocalDataSourceImpl implements LocalizationLocalDataSource {
  static const String _tableName = 'app_settings';
  
  @override
  Future<Locale?> getCurrentLocale() async {
    try {
      final db = await DatabaseService.instance;
      final result = await db.query(
        _tableName,
        where: 'locale IS NOT NULL',
        limit: 1,
      );
      
      if (result.isNotEmpty && result.first['locale'] != null) {
        final localeString = result.first['locale'] as String;
        final parts = localeString.split('_');
        return Locale(parts[0], parts.length > 1 ? parts[1] : null);
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }
  
  @override
  Future<void> setLocale(Locale locale) async {
    final db = await DatabaseService.instance;
    
    try {
      final existing = await db.query(_tableName, limit: 1);
      final localeString = locale.countryCode != null 
          ? '${locale.languageCode}_${locale.countryCode}'
          : locale.languageCode;
      
      if (existing.isNotEmpty) {
        await db.update(
          _tableName,
          {'locale': localeString},
          where: 'id = ?',
          whereArgs: [existing.first['id']],
        );
      } else {
        await db.insert(
          _tableName,
          {
            'locale': localeString,
            'is_dark_mode': null,
            'onboarding_completed': 0,
          },
        );
      }
    } catch (e) {
      
      rethrow;
    }
  }
}