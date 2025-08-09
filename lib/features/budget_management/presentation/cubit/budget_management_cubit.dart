import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/budget_entity.dart';
import '../../domain/usecases/budget_management/budget_management_usecases.dart';
import 'budget_management_state.dart';

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
    try {
      emit(BudgetManagementLoading());
      
      // Initialize predefined categories first
      await _initializeBudgetCategories();
      
      // Load all data
      await loadBudgetManagementData();
    } catch (e) {
      emit(BudgetManagementError('Failed to initialize budget management: ${e.toString()}'));
    }
  }

  Future<void> loadBudgetManagementData() async {
    try {
      emit(BudgetManagementLoading());
      
      final categories = await _getBudgetCategories();
      final expenseCategories = await _getExpenseBudgetCategories();
      final incomeCategories = await _getIncomeBudgetCategories();
      final budgetPlans = await _getBudgetPlans();
      final activeBudgetPlans = await _getActiveBudgetPlans();
      final budgetsByCategory = await _getBudgetsByCategory();
      final budgetSummary = await _getBudgetSummary();
      
      emit(BudgetManagementLoaded(
        categories: categories,
        expenseCategories: expenseCategories,
        incomeCategories: incomeCategories,
        budgetPlans: budgetPlans,
        activeBudgetPlans: activeBudgetPlans,
        budgetsByCategory: budgetsByCategory,
        budgetSummary: budgetSummary,
      ));
    } catch (e) {
      emit(BudgetManagementError('Failed to load budget management data: ${e.toString()}'));
    }
  }

  Future<void> createBudget({
    required String name,
    required String description,
    required String categoryId,
    required double amount,
    required BudgetPeriod period,
  }) async {
    try {
      emit(BudgetManagementLoading());
      
      await _createBudgetPlan(
        name: name,
        description: description,
        categoryId: categoryId,
        amount: amount,
        period: period,
      );
      
      emit(const BudgetManagementOperationSuccess('Budget plan created successfully'));
      
      // Reload data
      await loadBudgetManagementData();
    } catch (e) {
      emit(BudgetManagementError('Failed to create budget plan: ${e.toString()}'));
    }
  }

  Future<void> updateBudget(BudgetEntity budget) async {
    try {
      emit(BudgetManagementLoading());
      
      await _updateBudgetPlan(budget);
      
      emit(const BudgetManagementOperationSuccess('Budget plan updated successfully'));
      
      // Reload data
      await loadBudgetManagementData();
    } catch (e) {
      emit(BudgetManagementError('Failed to update budget plan: ${e.toString()}'));
    }
  }

  Future<void> deleteBudget(String id) async {
    try {
      emit(BudgetManagementLoading());
      
      await _deleteBudgetPlan(id);
      
      emit(const BudgetManagementOperationSuccess('Budget plan deleted successfully'));
      
      // Reload data
      await loadBudgetManagementData();
    } catch (e) {
      emit(BudgetManagementError('Failed to delete budget plan: ${e.toString()}'));
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