// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:sqflite/sqflite.dart' as _i3;

import '../../features/localization/data/datasources/localization_local_datasource.dart'
    as _i5;
import '../../features/localization/data/repositories/localization_repository_impl.dart'
    as _i7;
import '../../features/localization/domain/repositories/localization_repository.dart'
    as _i6;
import '../../features/localization/domain/usecases/change_locale.dart' as _i16;
import '../../features/onboarding/data/datasources/onboarding_local_datasource.dart'
    as _i8;
import '../../features/onboarding/data/repositories/onboarding_repository_impl.dart'
    as _i10;
import '../../features/onboarding/domain/repositories/onboarding_repository.dart'
    as _i9;
import '../../features/onboarding/domain/usecases/complete_onboarding.dart'
    as _i12;
import '../../features/onboarding/domain/usecases/get_onboarding_status.dart'
    as _i13;
import '../../features/onboarding/domain/usecases/reset_onboarding.dart'
    as _i11;
import '../../features/onboarding/domain/usecases/save_onboarding_settings.dart'
    as _i17;
import '../../features/onboarding/presentation/cubit/onboarding_cubit.dart'
    as _i15;
import '../localization/locale_manager.dart' as _i14;
import '../localization/locale_service.dart' as _i4;
import 'injection_module.dart' as _i18;

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
    await gh.factoryAsync<_i3.Database>(
      () => injectionModule.database,
      preResolve: true,
    );
    gh.factory<_i4.LocaleService>(
        () => _i4.LocaleServiceImpl(gh<_i3.Database>()));
    gh.factory<_i5.LocalizationLocalDataSource>(
        () => _i5.LocalizationLocalDataSourceImpl());
    gh.factory<_i6.LocalizationRepository>(() => _i7.LocalizationRepositoryImpl(
        localDataSource: gh<_i5.LocalizationLocalDataSource>()));
    gh.factory<_i8.OnboardingLocalDataSource>(
        () => _i8.OnboardingLocalDataSourceImpl());
    gh.factory<_i9.OnboardingRepository>(() => _i10.OnboardingRepositoryImpl(
        localDataSource: gh<_i8.OnboardingLocalDataSource>()));
    gh.factory<_i11.ResetOnboarding>(
        () => _i11.ResetOnboarding(gh<_i9.OnboardingRepository>()));
    gh.factory<_i12.CompleteOnboarding>(
        () => _i12.CompleteOnboarding(gh<_i9.OnboardingRepository>()));
    gh.factory<_i13.GetOnboardingStatus>(
        () => _i13.GetOnboardingStatus(gh<_i9.OnboardingRepository>()));
    gh.singleton<_i14.LocaleManager>(
        () => _i14.LocaleManager(gh<_i4.LocaleService>()));
    gh.factory<_i15.OnboardingCubit>(() => _i15.OnboardingCubit(
          gh<_i13.GetOnboardingStatus>(),
          gh<_i12.CompleteOnboarding>(),
          gh<_i11.ResetOnboarding>(),
        ));
    gh.factory<_i16.ChangeLocale>(() => _i16.ChangeLocale(
          gh<_i6.LocalizationRepository>(),
          gh<_i14.LocaleManager>(),
        ));
    gh.factory<_i17.SaveOnboardingSettings>(() => _i17.SaveOnboardingSettings(
          gh<_i9.OnboardingRepository>(),
          gh<_i16.ChangeLocale>(),
        ));
    return this;
  }
}

class _$InjectionModule extends _i18.InjectionModule {}
