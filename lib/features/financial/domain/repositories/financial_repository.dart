import '../../../category/domain/entities/category_entity.dart';
import '../../../budget/domain/entities/budget_entity.dart';

abstract class FinancialRepository {
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
  Future<String> createBudget(BudgetEntity budget);
  Future<void> updateBudget(BudgetEntity budget);
  Future<void> deleteBudget(String id);
  
  // Combined operations
  Future<Map<CategoryEntity, List<BudgetEntity>>> getBudgetsByCategory();
  Future<List<BudgetEntity>> getBudgetsForCategory(String categoryId);
  Future<double> getTotalBudgetForCategory(String categoryId);
  Future<Map<String, double>> getCategoryBudgetSummary();
}