import '../entities/budget_entity.dart';
import '../entities/category_entity.dart';

abstract class BudgetManagementRepository {
  // Category operations
  Future<List<CategoryEntity>> getAllCategories();
  Future<List<CategoryEntity>> getCategoriesByType(CategoryType type);
  Future<CategoryEntity?> getCategoryById(String id);
  Future<String> createCategory(CategoryEntity category);
  Future<void> updateCategory(CategoryEntity category);
  Future<void> deleteCategory(String id);
  Future<void> initializePredefinedCategories();

  // Budget operations
  Future<List<BudgetEntity>> getAllBudgets();
  Future<List<BudgetEntity>> getActiveBudgets();
  Future<BudgetEntity?> getBudgetById(String id);
  Future<List<BudgetEntity>> getBudgetsByCategory(String categoryId);
  Future<String> createBudget(BudgetEntity budget);
  Future<void> updateBudget(BudgetEntity budget);
  Future<void> deleteBudget(String id);

  // Combined operations
  Future<Map<CategoryEntity, List<BudgetEntity>>> getBudgetsGroupedByCategory();
  Future<List<BudgetEntity>> getBudgetsForCategory(String categoryId);
  Future<double> getTotalBudgetForCategory(String categoryId);
  Future<Map<String, double>> getCategoryBudgetSummary();
}