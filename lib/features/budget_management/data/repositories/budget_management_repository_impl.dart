import 'package:injectable/injectable.dart';
import 'package:cashflow/features/budget_management/data/datasources/budget_local_datasource.dart';
import 'package:cashflow/features/budget_management/data/datasources/category_local_datasource.dart';
import 'package:cashflow/features/budget_management/data/models/budget_model.dart';
import 'package:cashflow/features/budget_management/data/models/category_model.dart';
import 'package:cashflow/features/budget_management/domain/entities/budget_entity.dart';
import 'package:cashflow/features/budget_management/domain/entities/category_entity.dart';
import 'package:cashflow/features/budget_management/domain/repositories/budget_management_repository.dart';

@Injectable(as: BudgetManagementRepository)
class BudgetManagementRepositoryImpl implements BudgetManagementRepository {
  final BudgetLocalDataSource _budgetDataSource;
  final CategoryLocalDataSource _categoryDataSource;

  BudgetManagementRepositoryImpl({
    required BudgetLocalDataSource budgetDataSource,
    required CategoryLocalDataSource categoryDataSource,
  }) : _budgetDataSource = budgetDataSource,
       _categoryDataSource = categoryDataSource;

  // Category operations
  @override
  Future<List<CategoryEntity>> getAllCategories() async {
    final models = await _categoryDataSource.getAllCategories();
    return models.cast<CategoryEntity>();
  }

  @override
  Future<List<CategoryEntity>> getCategoriesByType(CategoryType type) async {
    final models = await _categoryDataSource.getCategoriesByType(type);
    return models.cast<CategoryEntity>();
  }

  @override
  Future<CategoryEntity?> getCategoryById(String id) async {
    final model = await _categoryDataSource.getCategoryById(id);
    return model;
  }

  @override
  Future<String> createCategory(CategoryEntity category) {
    final model = CategoryModel.fromEntity(category);
    return _categoryDataSource.insertCategory(model);
  }

  @override
  Future<void> updateCategory(CategoryEntity category) {
    final model = CategoryModel.fromEntity(category);
    return _categoryDataSource.updateCategory(model);
  }

  @override
  Future<void> deleteCategory(String id) => 
      _categoryDataSource.deleteCategory(id);

  @override
  Future<void> initializePredefinedCategories() => 
      _categoryDataSource.initializePredefinedCategories();

  // Budget operations
  @override
  Future<List<BudgetEntity>> getAllBudgets() async {
    final models = await _budgetDataSource.getAllBudgets();
    return models.cast<BudgetEntity>();
  }

  @override
  Future<List<BudgetEntity>> getActiveBudgets() async {
    final models = await _budgetDataSource.getActiveBudgets();
    return models.cast<BudgetEntity>();
  }

  @override
  Future<BudgetEntity?> getBudgetById(String id) async {
    final model = await _budgetDataSource.getBudgetById(id);
    return model;
  }

  @override
  Future<List<BudgetEntity>> getBudgetsByCategory(String categoryId) async {
    final models = await _budgetDataSource.getBudgetsByCategory(categoryId);
    return models.cast<BudgetEntity>();
  }

  @override
  Future<String> createBudget(BudgetEntity budget) {
    final model = BudgetModel.fromEntity(budget);
    return _budgetDataSource.insertBudget(model);
  }

  @override
  Future<void> updateBudget(BudgetEntity budget) {
    final model = BudgetModel.fromEntity(budget);
    return _budgetDataSource.updateBudget(model);
  }

  @override
  Future<void> deleteBudget(String id) => 
      _budgetDataSource.deleteBudget(id);

  // Combined operations
  @override
  Future<Map<CategoryEntity, List<BudgetEntity>>> getBudgetsGroupedByCategory() async {
    final categories = await _categoryDataSource.getAllCategories();
    final budgets = await _budgetDataSource.getAllBudgets();
    
    final Map<CategoryEntity, List<BudgetEntity>> result = {};
    
    for (final category in categories) {
      final categoryBudgets = budgets.where((budget) => budget.categoryId == category.id).toList();
      result[category] = categoryBudgets;
    }
    
    return result;
  }

  @override
  Future<List<BudgetEntity>> getBudgetsForCategory(String categoryId) async {
    return await _budgetDataSource.getBudgetsByCategory(categoryId);
  }

  @override
  Future<double> getTotalBudgetForCategory(String categoryId) async {
    final budgets = await _budgetDataSource.getBudgetsByCategory(categoryId);
    return budgets.fold<double>(0.0, (total, budget) => total + budget.amount);
  }

  @override
  Future<Map<String, double>> getCategoryBudgetSummary() async {
    final categories = await _categoryDataSource.getAllCategories();
    final Map<String, double> summary = {};
    
    for (final category in categories) {
      final totalBudget = await getTotalBudgetForCategory(category.id);
      if (totalBudget > 0) {
        summary[category.name] = totalBudget;
      }
    }
    
    return summary;
  }
}