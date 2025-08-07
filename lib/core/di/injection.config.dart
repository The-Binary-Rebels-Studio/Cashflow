// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:sqflite/sqflite.dart' as _i4;

import '../../features/localization/data/datasources/localization_local_datasource.dart'
    as _i7;
import '../../features/localization/data/repositories/localization_repository_impl.dart'
    as _i9;
import '../../features/localization/domain/repositories/localization_repository.dart'
    as _i8;
import '../../features/localization/domain/usecases/change_locale.dart' as _i17;
import '../../features/onboarding/data/datasources/onboarding_local_datasource.dart'
    as _i10;
import '../../features/onboarding/data/repositories/onboarding_repository_impl.dart'
    as _i12;
import '../../features/onboarding/domain/repositories/onboarding_repository.dart'
    as _i11;
import '../../features/onboarding/domain/usecases/complete_onboarding.dart'
    as _i14;
import '../../features/onboarding/domain/usecases/get_onboarding_status.dart'
    as _i15;
import '../../features/onboarding/domain/usecases/reset_onboarding.dart'
    as _i13;
import '../../features/onboarding/domain/usecases/save_onboarding_settings.dart'
    as _i19;
import '../../features/onboarding/presentation/cubit/onboarding_cubit.dart'
    as _i18;
import '../database/database_service.dart' as _i5;
import '../localization/locale_manager.dart' as _i16;
import '../localization/locale_service.dart' as _i6;
import '../services/currency_service.dart' as _i3;
import 'injection_module.dart' as _i20;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i1.GetIt> init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final injectionModule = _$InjectionModule();
    gh.singleton<_i3.CurrencyService>(() => injectionModule.currencyService);
    await gh.factoryAsync<_i4.Database>(
      () => injectionModule.database,
      preResolve: true,
    );
    gh.singleton<_i5.DatabaseService>(() => injectionModule.databaseService);
    gh.factory<_i6.LocaleService>(
        () => _i6.LocaleServiceImpl(gh<_i4.Database>()));
    gh.factory<_i7.LocalizationLocalDataSource>(
        () => _i7.LocalizationLocalDataSourceImpl());
    gh.factory<_i8.LocalizationRepository>(() => _i9.LocalizationRepositoryImpl(
        localDataSource: gh<_i7.LocalizationLocalDataSource>()));
    gh.factory<_i10.OnboardingLocalDataSource>(
        () => _i10.OnboardingLocalDataSourceImpl());
    gh.factory<_i11.OnboardingRepository>(() => _i12.OnboardingRepositoryImpl(
        localDataSource: gh<_i10.OnboardingLocalDataSource>()));
    gh.factory<_i13.ResetOnboarding>(
        () => _i13.ResetOnboarding(gh<_i11.OnboardingRepository>()));
    gh.factory<_i14.CompleteOnboarding>(
        () => _i14.CompleteOnboarding(gh<_i11.OnboardingRepository>()));
    gh.factory<_i15.GetOnboardingStatus>(
        () => _i15.GetOnboardingStatus(gh<_i11.OnboardingRepository>()));
    gh.singleton<_i16.LocaleManager>(
        () => _i16.LocaleManager(gh<_i6.LocaleService>()));
    gh.factory<_i17.ChangeLocale>(() => _i17.ChangeLocale(
          gh<_i8.LocalizationRepository>(),
          gh<_i16.LocaleManager>(),
        ));
    gh.factory<_i18.OnboardingCubit>(() => _i18.OnboardingCubit(
          gh<_i15.GetOnboardingStatus>(),
          gh<_i14.CompleteOnboarding>(),
          gh<_i13.ResetOnboarding>(),
          gh<_i17.ChangeLocale>(),
        ));
    gh.factory<_i19.SaveOnboardingSettings>(() => _i19.SaveOnboardingSettings(
          gh<_i11.OnboardingRepository>(),
          gh<_i17.ChangeLocale>(),
        ));
    return this;
  }
}

class _$InjectionModule extends _i20.InjectionModule {}
