import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:cashflow/core/error/failures.dart';
import 'package:cashflow/features/budget_management/domain/entities/category_entity.dart';
import 'package:cashflow/features/budget_management/domain/entities/budget_entity.dart';
import 'package:cashflow/features/budget_management/domain/usecases/budget_management/budget_management_usecases.dart';
import 'package:cashflow/features/budget_management/presentation/bloc/budget_management_event.dart';
import 'package:cashflow/features/budget_management/presentation/bloc/budget_management_state.dart';

@injectable
class BudgetManagementBloc extends Bloc<BudgetManagementEvent, BudgetManagementState> {
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

  BudgetManagementBloc(
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
  ) : super(BudgetManagementInitial()) {
    on<BudgetManagementInitialized>(_onInitialized);
    on<BudgetManagementDataRequested>(_onDataRequested);
    on<BudgetCreateRequested>(_onCreateRequested);
    on<BudgetUpdateRequested>(_onUpdateRequested);
    on<BudgetDeleteRequested>(_onDeleteRequested);
  }

  Future<void> _onInitialized(
    BudgetManagementInitialized event,
    Emitter<BudgetManagementState> emit,
  ) async {
    emit(BudgetManagementLoading());
    
    
    final initResult = await _initializeBudgetCategories();
    
    if (initResult.isFailure) {
      emit(BudgetManagementError(_getErrorMessage(initResult.failure!)));
      return;
    }
    
    
    add(const BudgetManagementDataRequested());
  }

  Future<void> _onDataRequested(
    BudgetManagementDataRequested event,
    Emitter<BudgetManagementState> emit,
  ) async {
    emit(BudgetManagementLoading());
    
    
    final results = await Future.wait([
      _getBudgetCategories(),
      _getExpenseBudgetCategories(),
      _getIncomeBudgetCategories(),
      _getBudgetPlans(),
      _getActiveBudgetPlans(),
      _getBudgetsByCategory(),
      _getBudgetSummary(),
    ]);
    
    
    for (final result in results) {
      if (result.isFailure) {
        emit(BudgetManagementError(_getErrorMessage(result.failure!)));
        return;
      }
    }
    
    
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

  Future<void> _onCreateRequested(
    BudgetCreateRequested event,
    Emitter<BudgetManagementState> emit,
  ) async {
    emit(BudgetManagementLoading());
    
    final result = await _createBudgetPlan(
      name: event.name,
      description: event.description,
      categoryId: event.categoryId,
      amount: event.amount,
      period: event.period,
    );
    
    result.fold(
      onSuccess: (_) async {
        emit(const BudgetManagementOperationSuccess('budgetCreatedSuccess'));
        
        add(const BudgetManagementDataRequested());
      },
      onFailure: (failure) => emit(BudgetManagementError(_getErrorMessage(failure))),
    );
  }

  Future<void> _onUpdateRequested(
    BudgetUpdateRequested event,
    Emitter<BudgetManagementState> emit,
  ) async {
    emit(BudgetManagementLoading());
    
    final result = await _updateBudgetPlan(event.budget);
    
    result.fold(
      onSuccess: (_) async {
        emit(const BudgetManagementOperationSuccess('budgetUpdatedSuccess'));
        
        add(const BudgetManagementDataRequested());
      },
      onFailure: (failure) => emit(BudgetManagementError(_getErrorMessage(failure))),
    );
  }

  Future<void> _onDeleteRequested(
    BudgetDeleteRequested event,
    Emitter<BudgetManagementState> emit,
  ) async {
    emit(BudgetManagementLoading());
    
    final result = await _deleteBudgetPlan(event.id);
    
    result.fold(
      onSuccess: (_) async {
        emit(const BudgetManagementOperationSuccess('budgetDeletedSuccess'));
        
        add(const BudgetManagementDataRequested());
      },
      onFailure: (failure) => emit(BudgetManagementError(_getErrorMessage(failure))),
    );
  }

  
  String _getErrorMessage(AppFailure failure) {
    switch (failure.runtimeType) {
      case ValidationFailure _:
        final validationFailure = failure as ValidationFailure;
        if (validationFailure.fieldErrors.isNotEmpty) {
          final firstError = validationFailure.fieldErrors.values.first.first;
          return firstError;
        }
        return validationFailure.message;
      
      case BudgetNotFoundFailure _:
        return 'Budget not found. Please try again.';
      
      case CategoryNotFoundFailure _:
        return 'Category not found. Please select a valid category.';
      
      case NetworkFailure _:
        return 'Network error. Please check your connection and try again.';
      
      case DatabaseFailure _:
        return 'Database error. Please try again later.';
      
      case BusinessLogicFailure _:
        return failure.message;
      
      default:
        return 'An unexpected error occurred. Please try again.';
    }
  }

  
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