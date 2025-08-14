// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cashflow/core/database/database_service.dart' as _i70;
import 'package:cashflow/core/di/injection_module.dart' as _i104;
import 'package:cashflow/core/localization/locale_bloc.dart' as _i581;
import 'package:cashflow/core/localization/locale_service.dart' as _i751;
import 'package:cashflow/core/services/ads_service.dart' as _i285;
import 'package:cashflow/core/services/currency_bloc.dart' as _i410;
import 'package:cashflow/features/budget_management/data/datasources/budget_local_datasource.dart'
    as _i297;
import 'package:cashflow/features/budget_management/data/datasources/category_local_datasource.dart'
    as _i985;
import 'package:cashflow/features/budget_management/data/repositories/budget_management_repository_impl.dart'
    as _i543;
import 'package:cashflow/features/budget_management/data/services/localized_category_service.dart'
    as _i570;
import 'package:cashflow/features/budget_management/domain/repositories/budget_management_repository.dart'
    as _i165;
import 'package:cashflow/features/budget_management/domain/usecases/budget_management/budget_management_usecases.dart'
    as _i458;
import 'package:cashflow/features/budget_management/presentation/bloc/budget_management_bloc.dart'
    as _i921;
import 'package:cashflow/features/localization/data/datasources/localization_local_datasource.dart'
    as _i176;
import 'package:cashflow/features/localization/data/repositories/localization_repository_impl.dart'
    as _i891;
import 'package:cashflow/features/localization/domain/repositories/localization_repository.dart'
    as _i738;
import 'package:cashflow/features/localization/domain/usecases/change_locale.dart'
    as _i563;
import 'package:cashflow/features/onboarding/data/datasources/onboarding_local_datasource.dart'
    as _i943;
import 'package:cashflow/features/onboarding/data/repositories/onboarding_repository_impl.dart'
    as _i454;
import 'package:cashflow/features/onboarding/domain/repositories/onboarding_repository.dart'
    as _i1001;
import 'package:cashflow/features/onboarding/domain/usecases/complete_onboarding.dart'
    as _i878;
import 'package:cashflow/features/onboarding/domain/usecases/get_onboarding_status.dart'
    as _i596;
import 'package:cashflow/features/onboarding/domain/usecases/reset_onboarding.dart'
    as _i212;
import 'package:cashflow/features/onboarding/domain/usecases/save_onboarding_settings.dart'
    as _i133;
import 'package:cashflow/features/onboarding/presentation/bloc/onboarding_bloc.dart'
    as _i669;
import 'package:cashflow/features/transaction/data/datasources/transaction_local_datasource.dart'
    as _i417;
import 'package:cashflow/features/transaction/data/repositories/transaction_repository_impl.dart'
    as _i106;
import 'package:cashflow/features/transaction/domain/repositories/transaction_repository.dart'
    as _i935;
import 'package:cashflow/features/transaction/domain/usecases/transaction_usecases.dart'
    as _i528;
import 'package:cashflow/features/transaction/presentation/bloc/transaction_bloc.dart'
    as _i23;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:sqflite/sqflite.dart' as _i779;

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
    gh.factory<_i570.LocalizedCategoryService>(
      () => _i570.LocalizedCategoryService(),
    );
    gh.singleton<_i70.DatabaseService>(() => injectionModule.databaseService);
    gh.singleton<_i285.AdsService>(() => _i285.AdsService());
    gh.factory<_i943.OnboardingLocalDataSource>(
      () => _i943.OnboardingLocalDataSourceImpl(),
    );
    gh.factory<_i176.LocalizationLocalDataSource>(
      () => _i176.LocalizationLocalDataSourceImpl(),
    );
    gh.factory<_i985.CategoryLocalDataSource>(
      () => _i985.CategoryLocalDataSourceImpl(gh<_i779.Database>()),
    );
    gh.factory<_i417.TransactionLocalDatasource>(
      () => _i417.TransactionLocalDatasourceImpl(gh<_i779.Database>()),
    );
    gh.factory<_i297.BudgetLocalDataSource>(
      () => _i297.BudgetLocalDataSourceImpl(gh<_i779.Database>()),
    );
    gh.factory<_i751.LocaleService>(
      () => _i751.LocaleServiceImpl(gh<_i779.Database>()),
    );
    gh.factory<_i165.BudgetManagementRepository>(
      () => _i543.BudgetManagementRepositoryImpl(
        budgetDataSource: gh<_i297.BudgetLocalDataSource>(),
        categoryDataSource: gh<_i985.CategoryLocalDataSource>(),
      ),
    );
    gh.singleton<_i581.LocaleBloc>(
      () => _i581.LocaleBloc(gh<_i751.LocaleService>()),
    );
    gh.singleton<_i410.CurrencyBloc>(
      () => _i410.CurrencyBloc(gh<_i70.DatabaseService>()),
    );
    gh.factory<_i458.GetBudgetCategories>(
      () => _i458.GetBudgetCategories(gh<_i165.BudgetManagementRepository>()),
    );
    gh.factory<_i458.GetExpenseBudgetCategories>(
      () => _i458.GetExpenseBudgetCategories(
        gh<_i165.BudgetManagementRepository>(),
      ),
    );
    gh.factory<_i458.GetIncomeBudgetCategories>(
      () => _i458.GetIncomeBudgetCategories(
        gh<_i165.BudgetManagementRepository>(),
      ),
    );
    gh.factory<_i458.GetBudgetPlans>(
      () => _i458.GetBudgetPlans(gh<_i165.BudgetManagementRepository>()),
    );
    gh.factory<_i458.GetActiveBudgetPlans>(
      () => _i458.GetActiveBudgetPlans(gh<_i165.BudgetManagementRepository>()),
    );
    gh.factory<_i458.GetBudgetsByCategory>(
      () => _i458.GetBudgetsByCategory(gh<_i165.BudgetManagementRepository>()),
    );
    gh.factory<_i458.GetBudgetSummary>(
      () => _i458.GetBudgetSummary(gh<_i165.BudgetManagementRepository>()),
    );
    gh.factory<_i458.CreateBudgetPlan>(
      () => _i458.CreateBudgetPlan(gh<_i165.BudgetManagementRepository>()),
    );
    gh.factory<_i458.UpdateBudgetPlan>(
      () => _i458.UpdateBudgetPlan(gh<_i165.BudgetManagementRepository>()),
    );
    gh.factory<_i458.DeleteBudgetPlan>(
      () => _i458.DeleteBudgetPlan(gh<_i165.BudgetManagementRepository>()),
    );
    gh.factory<_i458.InitializeBudgetCategories>(
      () => _i458.InitializeBudgetCategories(
        gh<_i165.BudgetManagementRepository>(),
      ),
    );
    gh.factory<_i1001.OnboardingRepository>(
      () => _i454.OnboardingRepositoryImpl(
        localDataSource: gh<_i943.OnboardingLocalDataSource>(),
      ),
    );
    gh.factory<_i878.CompleteOnboarding>(
      () => _i878.CompleteOnboarding(gh<_i1001.OnboardingRepository>()),
    );
    gh.factory<_i596.GetOnboardingStatus>(
      () => _i596.GetOnboardingStatus(gh<_i1001.OnboardingRepository>()),
    );
    gh.factory<_i212.ResetOnboarding>(
      () => _i212.ResetOnboarding(gh<_i1001.OnboardingRepository>()),
    );
    gh.factory<_i738.LocalizationRepository>(
      () => _i891.LocalizationRepositoryImpl(
        localDataSource: gh<_i176.LocalizationLocalDataSource>(),
      ),
    );
    gh.factory<_i935.TransactionRepository>(
      () => _i106.TransactionRepositoryImpl(
        localDatasource: gh<_i417.TransactionLocalDatasource>(),
        budgetManagementRepository: gh<_i165.BudgetManagementRepository>(),
      ),
    );
    gh.factory<_i563.ChangeLocale>(
      () => _i563.ChangeLocale(
        gh<_i738.LocalizationRepository>(),
        gh<_i581.LocaleBloc>(),
      ),
    );
    gh.factory<_i921.BudgetManagementBloc>(
      () => _i921.BudgetManagementBloc(
        gh<_i458.GetBudgetCategories>(),
        gh<_i458.GetExpenseBudgetCategories>(),
        gh<_i458.GetIncomeBudgetCategories>(),
        gh<_i458.GetBudgetPlans>(),
        gh<_i458.GetActiveBudgetPlans>(),
        gh<_i458.GetBudgetsByCategory>(),
        gh<_i458.GetBudgetSummary>(),
        gh<_i458.CreateBudgetPlan>(),
        gh<_i458.UpdateBudgetPlan>(),
        gh<_i458.DeleteBudgetPlan>(),
        gh<_i458.InitializeBudgetCategories>(),
      ),
    );
    gh.factory<_i669.OnboardingBloc>(
      () => _i669.OnboardingBloc(
        gh<_i596.GetOnboardingStatus>(),
        gh<_i878.CompleteOnboarding>(),
        gh<_i212.ResetOnboarding>(),
        gh<_i563.ChangeLocale>(),
      ),
    );
    gh.factory<_i528.TransactionUsecases>(
      () => _i528.TransactionUsecases(
        transactionRepository: gh<_i935.TransactionRepository>(),
        budgetRepository: gh<_i165.BudgetManagementRepository>(),
      ),
    );
    gh.factory<_i133.SaveOnboardingSettings>(
      () => _i133.SaveOnboardingSettings(
        gh<_i1001.OnboardingRepository>(),
        gh<_i563.ChangeLocale>(),
      ),
    );
    gh.factory<_i23.TransactionBloc>(
      () => _i23.TransactionBloc(
        gh<_i528.TransactionUsecases>(),
        gh<_i165.BudgetManagementRepository>(),
      ),
    );
    return this;
  }
}

class _$InjectionModule extends _i104.InjectionModule {}
