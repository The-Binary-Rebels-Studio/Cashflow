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

import '../../features/budget/data/datasources/budget_local_datasource.dart'
    as _i441;
import '../../features/budget/data/repositories/budget_repository_impl.dart'
    as _i74;
import '../../features/budget/domain/repositories/budget_repository.dart'
    as _i438;
import '../../features/budget/domain/usecases/get_budgets.dart' as _i120;
import '../../features/budget/domain/usecases/manage_budget.dart' as _i877;
import '../../features/budget/presentation/cubit/budget_cubit.dart' as _i269;
import '../../features/category/data/datasources/category_local_datasource.dart'
    as _i759;
import '../../features/category/data/repositories/category_repository_impl.dart'
    as _i528;
import '../../features/category/domain/repositories/category_repository.dart'
    as _i869;
import '../../features/category/domain/usecases/get_categories.dart' as _i590;
import '../../features/category/domain/usecases/manage_category.dart' as _i757;
import '../../features/category/presentation/cubit/category_cubit.dart'
    as _i859;
import '../../features/financial/data/repositories/financial_repository_impl.dart'
    as _i467;
import '../../features/financial/domain/repositories/financial_repository.dart'
    as _i631;
import '../../features/financial/domain/usecases/budget_management_usecases.dart'
    as _i877;
import '../../features/financial/presentation/cubit/budget_management_cubit.dart'
    as _i830;
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
    gh.factory<_i759.CategoryLocalDataSource>(
      () => _i759.CategoryLocalDataSourceImpl(gh<_i779.Database>()),
    );
    gh.factory<_i441.BudgetLocalDataSource>(
      () => _i441.BudgetLocalDataSourceImpl(gh<_i779.Database>()),
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
    gh.factory<_i869.CategoryRepository>(
      () => _i528.CategoryRepositoryImpl(
        localDataSource: gh<_i759.CategoryLocalDataSource>(),
      ),
    );
    gh.factory<_i438.BudgetRepository>(
      () => _i74.BudgetRepositoryImpl(
        localDataSource: gh<_i441.BudgetLocalDataSource>(),
      ),
    );
    gh.factory<_i902.SaveOnboardingSettings>(
      () => _i902.SaveOnboardingSettings(
        gh<_i430.OnboardingRepository>(),
        gh<_i53.ChangeLocale>(),
      ),
    );
    gh.factory<_i631.FinancialRepository>(
      () => _i467.FinancialRepositoryImpl(
        categoryRepository: gh<_i869.CategoryRepository>(),
        budgetRepository: gh<_i438.BudgetRepository>(),
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
    gh.factory<_i590.GetCategories>(
      () => _i590.GetCategories(gh<_i869.CategoryRepository>()),
    );
    gh.factory<_i590.GetCategoriesByType>(
      () => _i590.GetCategoriesByType(gh<_i869.CategoryRepository>()),
    );
    gh.factory<_i757.CreateCategory>(
      () => _i757.CreateCategory(gh<_i869.CategoryRepository>()),
    );
    gh.factory<_i757.UpdateCategory>(
      () => _i757.UpdateCategory(gh<_i869.CategoryRepository>()),
    );
    gh.factory<_i757.DeleteCategory>(
      () => _i757.DeleteCategory(gh<_i869.CategoryRepository>()),
    );
    gh.factory<_i757.InitializePredefinedCategories>(
      () =>
          _i757.InitializePredefinedCategories(gh<_i869.CategoryRepository>()),
    );
    gh.factory<_i877.GetBudgetCategories>(
      () => _i877.GetBudgetCategories(gh<_i631.FinancialRepository>()),
    );
    gh.factory<_i877.GetExpenseBudgetCategories>(
      () => _i877.GetExpenseBudgetCategories(gh<_i631.FinancialRepository>()),
    );
    gh.factory<_i877.GetIncomeBudgetCategories>(
      () => _i877.GetIncomeBudgetCategories(gh<_i631.FinancialRepository>()),
    );
    gh.factory<_i877.GetBudgetPlans>(
      () => _i877.GetBudgetPlans(gh<_i631.FinancialRepository>()),
    );
    gh.factory<_i877.GetActiveBudgetPlans>(
      () => _i877.GetActiveBudgetPlans(gh<_i631.FinancialRepository>()),
    );
    gh.factory<_i877.GetBudgetsByCategory>(
      () => _i877.GetBudgetsByCategory(gh<_i631.FinancialRepository>()),
    );
    gh.factory<_i877.GetBudgetSummary>(
      () => _i877.GetBudgetSummary(gh<_i631.FinancialRepository>()),
    );
    gh.factory<_i877.CreateBudgetPlan>(
      () => _i877.CreateBudgetPlan(gh<_i631.FinancialRepository>()),
    );
    gh.factory<_i877.UpdateBudgetPlan>(
      () => _i877.UpdateBudgetPlan(gh<_i631.FinancialRepository>()),
    );
    gh.factory<_i877.DeleteBudgetPlan>(
      () => _i877.DeleteBudgetPlan(gh<_i631.FinancialRepository>()),
    );
    gh.factory<_i877.InitializeBudgetCategories>(
      () => _i877.InitializeBudgetCategories(gh<_i631.FinancialRepository>()),
    );
    gh.factory<_i877.CreateBudget>(
      () => _i877.CreateBudget(gh<_i438.BudgetRepository>()),
    );
    gh.factory<_i877.UpdateBudget>(
      () => _i877.UpdateBudget(gh<_i438.BudgetRepository>()),
    );
    gh.factory<_i877.DeleteBudget>(
      () => _i877.DeleteBudget(gh<_i438.BudgetRepository>()),
    );
    gh.factory<_i120.GetBudgets>(
      () => _i120.GetBudgets(gh<_i438.BudgetRepository>()),
    );
    gh.factory<_i120.GetActiveBudgets>(
      () => _i120.GetActiveBudgets(gh<_i438.BudgetRepository>()),
    );
    gh.factory<_i120.GetBudgetsByPeriod>(
      () => _i120.GetBudgetsByPeriod(gh<_i438.BudgetRepository>()),
    );
    gh.factory<_i120.GetCurrentPeriodBudgets>(
      () => _i120.GetCurrentPeriodBudgets(gh<_i438.BudgetRepository>()),
    );
    gh.factory<_i830.BudgetManagementCubit>(
      () => _i830.BudgetManagementCubit(
        gh<_i877.GetBudgetCategories>(),
        gh<_i877.GetExpenseBudgetCategories>(),
        gh<_i877.GetIncomeBudgetCategories>(),
        gh<_i877.GetBudgetPlans>(),
        gh<_i877.GetActiveBudgetPlans>(),
        gh<_i877.GetBudgetsByCategory>(),
        gh<_i877.GetBudgetSummary>(),
        gh<_i877.CreateBudgetPlan>(),
        gh<_i877.UpdateBudgetPlan>(),
        gh<_i877.DeleteBudgetPlan>(),
        gh<_i877.InitializeBudgetCategories>(),
      ),
    );
    gh.factory<_i859.CategoryCubit>(
      () => _i859.CategoryCubit(
        gh<_i590.GetCategories>(),
        gh<_i590.GetCategoriesByType>(),
        gh<_i757.CreateCategory>(),
        gh<_i757.UpdateCategory>(),
        gh<_i757.DeleteCategory>(),
        gh<_i757.InitializePredefinedCategories>(),
      ),
    );
    gh.factory<_i269.BudgetCubit>(
      () => _i269.BudgetCubit(
        gh<_i120.GetBudgets>(),
        gh<_i120.GetActiveBudgets>(),
        gh<_i120.GetBudgetsByPeriod>(),
        gh<_i120.GetCurrentPeriodBudgets>(),
        gh<_i877.CreateBudget>(),
        gh<_i877.UpdateBudget>(),
        gh<_i877.DeleteBudget>(),
      ),
    );
    return this;
  }
}

class _$InjectionModule extends _i212.InjectionModule {}
