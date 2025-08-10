import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:cashflow/core/error/failures.dart';
import 'package:cashflow/features/budget_management/domain/entities/category_entity.dart';
import 'package:cashflow/features/budget_management/domain/entities/budget_entity.dart';
import 'package:cashflow/features/budget_management/domain/usecases/budget_management/budget_management_usecases.dart';
import 'package:cashflow/features/budget_management/presentation/cubit/budget_management_state.dart';

@injectable
class BudgetManagementCubit extends Cubit<BudgetManagementState> {
  final GetBudgetCategories _getBudgetCategories;
  final GetExpenseBudgetCategories _getExpenseBudgetCategories;
  final GetIncomeBudgetCategories _getIncomeBudgetCategories;
  final GetBudgetPlans _getBudgetPlans;
  final GetActiveBudgetPlans _getActiveBudgetPlans;
  final GetBudgetsByCategory _getBudgetsByCategory;
  final GetBudgetSummary _getBudgetSummary;
  final CreateBudgetPlan _createBudgetPlan;
  final UpdateBudgetPlan _updateBudgetPlan;
  final DeleteBudgetPlan _deleteBudgetPlan;
  final InitializeBudgetCategories _initializeBudgetCategories;

  BudgetManagementCubit(
    this._getBudgetCategories,
    this._getExpenseBudgetCategories,
    this._getIncomeBudgetCategories,
    this._getBudgetPlans,
    this._getActiveBudgetPlans,
    this._getBudgetsByCategory,
    this._getBudgetSummary,
    this._createBudgetPlan,
    this._updateBudgetPlan,
    this._deleteBudgetPlan,
    this._initializeBudgetCategories,
  ) : super(BudgetManagementInitial());

  Future<void> initializeBudgetManagement() async {
    emit(BudgetManagementLoading());
    
    // Initialize predefined categories first
    final initResult = await _initializeBudgetCategories();
    
    if (initResult.isFailure) {
      emit(BudgetManagementError(_getErrorMessage(initResult.failure!)));
      return;
    }
    
    // Load all data
    await loadBudgetManagementData();
  }

  Future<void> loadBudgetManagementData() async {
    emit(BudgetManagementLoading());
    
    // Execute all use cases and collect results
    final results = await Future.wait([
      _getBudgetCategories(),
      _getExpenseBudgetCategories(),
      _getIncomeBudgetCategories(),
      _getBudgetPlans(),
      _getActiveBudgetPlans(),
      _getBudgetsByCategory(),
      _getBudgetSummary(),
    ]);
    
    // Check if any operation failed
    for (final result in results) {
      if (result.isFailure) {
        emit(BudgetManagementError(_getErrorMessage(result.failure!)));
        return;
      }
    }
    
    // All operations succeeded, extract values
    final categories = results[0].value as List<CategoryEntity>;
    final expenseCategories = results[1].value as List<CategoryEntity>;
    final incomeCategories = results[2].value as List<CategoryEntity>;
    final budgetPlans = results[3].value as List<BudgetEntity>;
    final activeBudgetPlans = results[4].value as List<BudgetEntity>;
    final budgetsByCategory = results[5].value as Map<CategoryEntity, List<BudgetEntity>>;
    final budgetSummary = results[6].value as Map<String, double>;
    
    emit(BudgetManagementLoaded(
      categories: categories,
      expenseCategories: expenseCategories,
      incomeCategories: incomeCategories,
      budgetPlans: budgetPlans,
      activeBudgetPlans: activeBudgetPlans,
      budgetsByCategory: budgetsByCategory,
      budgetSummary: budgetSummary,
    ));
  }

  Future<void> createBudget({
    required String name,
    required String description,
    required String categoryId,
    required double amount,
    required BudgetPeriod period,
  }) async {
    emit(BudgetManagementLoading());
    
    final result = await _createBudgetPlan(
      name: name,
      description: description,
      categoryId: categoryId,
      amount: amount,
      period: period,
    );
    
    result.fold(
      onSuccess: (_) async {
        emit(const BudgetManagementOperationSuccess('budgetCreatedSuccess'));
        // Reload data
        await loadBudgetManagementData();
      },
      onFailure: (failure) => emit(BudgetManagementError(_getErrorMessage(failure))),
    );
  }

  Future<void> updateBudget(BudgetEntity budget) async {
    emit(BudgetManagementLoading());
    
    final result = await _updateBudgetPlan(budget);
    
    result.fold(
      onSuccess: (_) async {
        emit(const BudgetManagementOperationSuccess('budgetUpdatedSuccess'));
        // Reload data
        await loadBudgetManagementData();
      },
      onFailure: (failure) => emit(BudgetManagementError(_getErrorMessage(failure))),
    );
  }

  Future<void> deleteBudget(String id) async {
    emit(BudgetManagementLoading());
    
    final result = await _deleteBudgetPlan(id);
    
    result.fold(
      onSuccess: (_) async {
        emit(const BudgetManagementOperationSuccess('budgetDeletedSuccess'));
        // Reload data
        await loadBudgetManagementData();
      },
      onFailure: (failure) => emit(BudgetManagementError(_getErrorMessage(failure))),
    );
  }

  /// Convert AppFailure to user-friendly error message
  String _getErrorMessage(AppFailure failure) {
    switch (failure.runtimeType) {
      case ValidationFailure:
        final validationFailure = failure as ValidationFailure;
        if (validationFailure.fieldErrors.isNotEmpty) {
          final firstError = validationFailure.fieldErrors.values.first.first;
          return firstError;
        }
        return validationFailure.message;
      
      case BudgetNotFoundFailure:
        return 'Budget not found. Please try again.';
      
      case CategoryNotFoundFailure:
        return 'Category not found. Please select a valid category.';
      
      case NetworkFailure:
        return 'Network error. Please check your connection and try again.';
      
      case DatabaseFailure:
        return 'Database error. Please try again later.';
      
      case BusinessLogicFailure:
        return failure.message;
      
      default:
        return 'An unexpected error occurred. Please try again.';
    }
  }

  // Convenience getters
  List<CategoryEntity> get budgetCategories {
    final currentState = state;
    if (currentState is BudgetManagementLoaded) {
      return currentState.categories;
    }
    return [];
  }

  List<CategoryEntity> get expenseBudgetCategories {
    final currentState = state;
    if (currentState is BudgetManagementLoaded) {
      return currentState.expenseCategories;
    }
    return [];
  }

  List<BudgetEntity> get activeBudgetPlans {
    final currentState = state;
    if (currentState is BudgetManagementLoaded) {
      return currentState.activeBudgetPlans;
    }
    return [];
  }

  Map<String, double> get budgetSummary {
    final currentState = state;
    if (currentState is BudgetManagementLoaded) {
      return currentState.budgetSummary;
    }
    return {};
  }
}