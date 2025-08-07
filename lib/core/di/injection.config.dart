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

import '../localization/locale_manager.dart' as _i5;
import '../localization/locale_service.dart' as _i4;
import 'injection_module.dart' as _i6;

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
    gh.singleton<_i5.LocaleManager>(
        () => _i5.LocaleManager(gh<_i4.LocaleService>()));
    return this;
  }
}

class _$InjectionModule extends _i6.InjectionModule {}
