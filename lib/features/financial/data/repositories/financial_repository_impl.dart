import 'package:injectable/injectable.dart';
import '../../../category/domain/entities/category_entity.dart';
import '../../../category/domain/repositories/category_repository.dart';
import '../../../budget/domain/entities/budget_entity.dart';
import '../../../budget/domain/repositories/budget_repository.dart';
import '../../domain/repositories/financial_repository.dart';

@Injectable(as: FinancialRepository)
class FinancialRepositoryImpl implements FinancialRepository {
  final CategoryRepository _categoryRepository;
  final BudgetRepository _budgetRepository;

  FinancialRepositoryImpl({
    required CategoryRepository categoryRepository,
    required BudgetRepository budgetRepository,
  }) : _categoryRepository = categoryRepository, _budgetRepository = budgetRepository;

  // Category operations - delegate to CategoryRepository
  @override
  Future<List<CategoryEntity>> getAllCategories() => _categoryRepository.getAllCategories();

  @override
  Future<List<CategoryEntity>> getCategoriesByType(CategoryType type) => 
      _categoryRepository.getCategoriesByType(type);

  @override
  Future<CategoryEntity?> getCategoryById(String id) => _categoryRepository.getCategoryById(id);

  @override
  Future<String> createCategory(CategoryEntity category) => _categoryRepository.createCategory(category);

  @override
  Future<void> updateCategory(CategoryEntity category) => _categoryRepository.updateCategory(category);

  @override
  Future<void> deleteCategory(String id) => _categoryRepository.deleteCategory(id);

  @override
  Future<void> initializePredefinedCategories() => _categoryRepository.initializePredefinedCategories();

  // Budget operations - delegate to BudgetRepository
  @override
  Future<List<BudgetEntity>> getAllBudgets() => _budgetRepository.getAllBudgets();

  @override
  Future<List<BudgetEntity>> getActiveBudgets() => _budgetRepository.getActiveBudgets();

  @override
  Future<BudgetEntity?> getBudgetById(String id) => _budgetRepository.getBudgetById(id);

  @override
  Future<String> createBudget(BudgetEntity budget) => _budgetRepository.createBudget(budget);

  @override
  Future<void> updateBudget(BudgetEntity budget) => _budgetRepository.updateBudget(budget);

  @override
  Future<void> deleteBudget(String id) => _budgetRepository.deleteBudget(id);

  // Combined operations
  @override
  Future<Map<CategoryEntity, List<BudgetEntity>>> getBudgetsByCategory() async {
    final categories = await _categoryRepository.getAllCategories();
    final budgets = await _budgetRepository.getAllBudgets();
    
    final Map<CategoryEntity, List<BudgetEntity>> result = {};
    
    for (final category in categories) {
      final categoryBudgets = budgets.where((budget) => budget.categoryId == category.id).toList();
      result[category] = categoryBudgets;
    }
    
    return result;
  }

  @override
  Future<List<BudgetEntity>> getBudgetsForCategory(String categoryId) async {
    return await _budgetRepository.getBudgetsByCategory(categoryId);
  }

  @override
  Future<double> getTotalBudgetForCategory(String categoryId) async {
    final budgets = await _budgetRepository.getBudgetsByCategory(categoryId);
    return budgets.fold<double>(0.0, (total, budget) => total + budget.amount);
  }

  @override
  Future<Map<String, double>> getCategoryBudgetSummary() async {
    final categories = await _categoryRepository.getAllCategories();
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