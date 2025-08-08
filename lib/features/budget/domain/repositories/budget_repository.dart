import '../entities/budget_entity.dart';

abstract class BudgetRepository {
  Future<List<BudgetEntity>> getAllBudgets();
  Future<List<BudgetEntity>> getActiveBudgets();
  Future<List<BudgetEntity>> getBudgetsByPeriod(BudgetPeriod period);
  Future<BudgetEntity?> getBudgetById(String id);
  Future<List<BudgetEntity>> getBudgetsByCategory(String categoryId);
  Future<String> createBudget(BudgetEntity budget);
  Future<void> updateBudget(BudgetEntity budget);
  Future<void> deleteBudget(String id);
  Future<int> getBudgetsCount();
  Future<List<BudgetEntity>> searchBudgets(String query);
  Future<List<BudgetEntity>> getCurrentPeriodBudgets();
}