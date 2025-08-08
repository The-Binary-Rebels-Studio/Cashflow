// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:sqflite/sqflite.dart' as _i779;

import '../../features/localization/data/datasources/localization_local_datasource.dart'
    as _i800;
import '../../features/localization/data/repositories/localization_repository_impl.dart'
    as _i172;
import '../../features/localization/domain/repositories/localization_repository.dart'
    as _i1044;
import '../../features/localization/domain/usecases/change_locale.dart' as _i53;
import '../../features/onboarding/data/datasources/onboarding_local_datasource.dart'
    as _i804;
import '../../features/onboarding/data/repositories/onboarding_repository_impl.dart'
    as _i452;
import '../../features/onboarding/domain/repositories/onboarding_repository.dart'
    as _i430;
import '../../features/onboarding/domain/usecases/complete_onboarding.dart'
    as _i561;
import '../../features/onboarding/domain/usecases/get_onboarding_status.dart'
    as _i52;
import '../../features/onboarding/domain/usecases/reset_onboarding.dart'
    as _i390;
import '../../features/onboarding/domain/usecases/save_onboarding_settings.dart'
    as _i902;
import '../../features/onboarding/presentation/cubit/onboarding_cubit.dart'
    as _i807;
import '../database/database_service.dart' as _i711;
import '../localization/locale_manager.dart' as _i71;
import '../localization/locale_service.dart' as _i339;
import '../services/currency_service.dart' as _i31;
import 'injection_module.dart' as _i212;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final injectionModule = _$InjectionModule();
    await gh.factoryAsync<_i779.Database>(
      () => injectionModule.database,
      preResolve: true,
    );
    gh.singleton<_i711.DatabaseService>(() => injectionModule.databaseService);
    gh.factory<_i804.OnboardingLocalDataSource>(
      () => _i804.OnboardingLocalDataSourceImpl(),
    );
    gh.factory<_i800.LocalizationLocalDataSource>(
      () => _i800.LocalizationLocalDataSourceImpl(),
    );
    gh.factory<_i339.LocaleService>(
      () => _i339.LocaleServiceImpl(gh<_i779.Database>()),
    );
    gh.singleton<_i71.LocaleManager>(
      () => _i71.LocaleManager(gh<_i339.LocaleService>()),
    );
    gh.singleton<_i31.CurrencyService>(
      () => _i31.CurrencyService(gh<_i711.DatabaseService>()),
    );
    gh.factory<_i430.OnboardingRepository>(
      () => _i452.OnboardingRepositoryImpl(
        localDataSource: gh<_i804.OnboardingLocalDataSource>(),
      ),
    );
    gh.factory<_i561.CompleteOnboarding>(
      () => _i561.CompleteOnboarding(gh<_i430.OnboardingRepository>()),
    );
    gh.factory<_i52.GetOnboardingStatus>(
      () => _i52.GetOnboardingStatus(gh<_i430.OnboardingRepository>()),
    );
    gh.factory<_i390.ResetOnboarding>(
      () => _i390.ResetOnboarding(gh<_i430.OnboardingRepository>()),
    );
    gh.factory<_i1044.LocalizationRepository>(
      () => _i172.LocalizationRepositoryImpl(
        localDataSource: gh<_i800.LocalizationLocalDataSource>(),
      ),
    );
    gh.factory<_i53.ChangeLocale>(
      () => _i53.ChangeLocale(
        gh<_i1044.LocalizationRepository>(),
        gh<_i71.LocaleManager>(),
      ),
    );
    gh.factory<_i902.SaveOnboardingSettings>(
      () => _i902.SaveOnboardingSettings(
        gh<_i430.OnboardingRepository>(),
        gh<_i53.ChangeLocale>(),
      ),
    );
    gh.factory<_i807.OnboardingCubit>(
      () => _i807.OnboardingCubit(
        gh<_i52.GetOnboardingStatus>(),
        gh<_i561.CompleteOnboarding>(),
        gh<_i390.ResetOnboarding>(),
        gh<_i53.ChangeLocale>(),
      ),
    );
    return this;
  }
}

class _$InjectionModule extends _i212.InjectionModule {}
