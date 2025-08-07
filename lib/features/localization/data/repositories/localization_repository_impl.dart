import 'package:injectable/injectable.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/app_locale.dart';
import '../../domain/repositories/localization_repository.dart';
import '../datasources/localization_local_datasource.dart';

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