import 'package:injectable/injectable.dart';
import 'package:flutter/material.dart';
import 'package:cashflow/features/localization/domain/entities/app_locale.dart';
import 'package:cashflow/features/localization/domain/repositories/localization_repository.dart';
import 'package:cashflow/features/localization/data/datasources/localization_local_datasource.dart';

@Injectable(as: LocalizationRepository)
class LocalizationRepositoryImpl implements LocalizationRepository {
  final LocalizationLocalDataSource localDataSource;
  
  const LocalizationRepositoryImpl({
    required this.localDataSource,
  });
  
  @override
  Future<Locale?> getCurrentLocale() async {
    return await localDataSource.getCurrentLocale();
  }
  
  @override
  Future<void> setLocale(Locale locale) async {
    await localDataSource.setLocale(locale);
  }
  
  @override
  List<AppLocale> getSupportedLocales() {
    return const [
      AppLocale(
        locale: Locale('en'),
        displayName: 'English',
      ),
      AppLocale(
        locale: Locale('id'),
        displayName: 'Indonesian',
      ),
      AppLocale(
        locale: Locale('ms'),
        displayName: 'Malay',
      ),
    ];
  }
}