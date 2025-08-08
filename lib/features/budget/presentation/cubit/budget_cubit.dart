import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/budget_entity.dart';
import '../../domain/usecases/get_budgets.dart';
import '../../domain/usecases/manage_budget.dart';
import 'budget_state.dart';

@injectable
class BudgetCubit extends Cubit<BudgetState> {
  final GetBudgets _getBudgets;
  final GetActiveBudgets _getActiveBudgets;
  final GetBudgetsByPeriod _getBudgetsByPeriod;
  final GetCurrentPeriodBudgets _getCurrentPeriodBudgets;
  final CreateBudget _createBudget;
  final UpdateBudget _updateBudget;
  final DeleteBudget _deleteBudget;

  BudgetCubit(
    this._getBudgets,
    this._getActiveBudgets,
    this._getBudgetsByPeriod,
    this._getCurrentPeriodBudgets,
    this._createBudget,
    this._updateBudget,
    this._deleteBudget,
  ) : super(BudgetInitial());

  Future<void> initializeBudgets() async {
    try {
      await loadBudgets();
    } catch (e) {
      emit(BudgetError('Failed to initialize budgets: ${e.toString()}'));
    }
  }

  Future<void> loadBudgets() async {
    try {
      emit(BudgetLoading());
      
      final allBudgets = await _getBudgets();
      final activeBudgets = await _getActiveBudgets();
      final currentPeriodBudgets = await _getCurrentPeriodBudgets();
      
      emit(BudgetLoaded(
        budgets: allBudgets,
        activeBudgets: activeBudgets,
        currentPeriodBudgets: currentPeriodBudgets,
      ));
    } catch (e) {
      emit(BudgetError('Failed to load budgets: ${e.toString()}'));
    }
  }

  Future<void> createNewBudget(BudgetEntity budget) async {
    try {
      emit(BudgetLoading());
      
      await _createBudget(budget);
      emit(const BudgetOperationSuccess('Budget created successfully'));
      
      // Reload budgets
      await loadBudgets();
    } catch (e) {
      emit(BudgetError('Failed to create budget: ${e.toString()}'));
    }
  }

  Future<void> updateExistingBudget(BudgetEntity budget) async {
    try {
      emit(BudgetLoading());
      
      await _updateBudget(budget);
      emit(const BudgetOperationSuccess('Budget updated successfully'));
      
      // Reload budgets
      await loadBudgets();
    } catch (e) {
      emit(BudgetError('Failed to update budget: ${e.toString()}'));
    }
  }

  Future<void> deleteExistingBudget(String id) async {
    try {
      emit(BudgetLoading());
      
      await _deleteBudget(id);
      emit(const BudgetOperationSuccess('Budget deleted successfully'));
      
      // Reload budgets
      await loadBudgets();
    } catch (e) {
      emit(BudgetError('Failed to delete budget: ${e.toString()}'));
    }
  }

  Future<void> loadBudgetsByPeriod(BudgetPeriod period) async {
    try {
      emit(BudgetLoading());
      
      final budgets = await _getBudgetsByPeriod(period);
      final activeBudgets = await _getActiveBudgets();
      final currentPeriodBudgets = await _getCurrentPeriodBudgets();
      
      emit(BudgetLoaded(
        budgets: budgets,
        activeBudgets: activeBudgets,
        currentPeriodBudgets: currentPeriodBudgets,
      ));
    } catch (e) {
      emit(BudgetError('Failed to load budgets by period: ${e.toString()}'));
    }
  }

  List<BudgetEntity> get currentBudgets {
    final currentState = state;
    if (currentState is BudgetLoaded) {
      return currentState.budgets;
    }
    return [];
  }

  List<BudgetEntity> get activeBudgets {
    final currentState = state;
    if (currentState is BudgetLoaded) {
      return currentState.activeBudgets;
    }
    return [];
  }
}