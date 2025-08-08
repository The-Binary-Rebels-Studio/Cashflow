import 'package:injectable/injectable.dart';
import '../../domain/entities/budget_entity.dart';
import '../../domain/repositories/budget_repository.dart';
import '../datasources/budget_local_datasource.dart';
import '../models/budget_model.dart';

@Injectable(as: BudgetRepository)
class BudgetRepositoryImpl implements BudgetRepository {
  final BudgetLocalDataSource _localDataSource;

  BudgetRepositoryImpl({required BudgetLocalDataSource localDataSource})
      : _localDataSource = localDataSource;

  @override
  Future<List<BudgetEntity>> getAllBudgets() async {
    final budgets = await _localDataSource.getAllBudgets();
    return budgets.map((model) => model as BudgetEntity).toList();
  }

  @override
  Future<List<BudgetEntity>> getActiveBudgets() async {
    final budgets = await _localDataSource.getActiveBudgets();
    return budgets.map((model) => model as BudgetEntity).toList();
  }

  @override
  Future<List<BudgetEntity>> getBudgetsByPeriod(BudgetPeriod period) async {
    final budgets = await _localDataSource.getBudgetsByPeriod(period);
    return budgets.map((model) => model as BudgetEntity).toList();
  }

  @override
  Future<BudgetEntity?> getBudgetById(String id) async {
    final budget = await _localDataSource.getBudgetById(id);
    return budget;
  }

  @override
  Future<List<BudgetEntity>> getBudgetsByCategory(String categoryId) async {
    final budgets = await _localDataSource.getBudgetsByCategory(categoryId);
    return budgets.map((model) => model as BudgetEntity).toList();
  }

  @override
  Future<String> createBudget(BudgetEntity budget) async {
    final budgetModel = BudgetModel.fromEntity(budget);
    return await _localDataSource.insertBudget(budgetModel);
  }

  @override
  Future<void> updateBudget(BudgetEntity budget) async {
    final budgetModel = BudgetModel.fromEntity(budget);
    await _localDataSource.updateBudget(budgetModel);
  }

  @override
  Future<void> deleteBudget(String id) async {
    await _localDataSource.deleteBudget(id);
  }

  @override
  Future<int> getBudgetsCount() async {
    return await _localDataSource.getBudgetsCount();
  }

  @override
  Future<List<BudgetEntity>> searchBudgets(String query) async {
    final budgets = await _localDataSource.searchBudgets(query);
    return budgets.map((model) => model as BudgetEntity).toList();
  }

  @override
  Future<List<BudgetEntity>> getCurrentPeriodBudgets() async {
    final budgets = await _localDataSource.getCurrentPeriodBudgets();
    return budgets.map((model) => model as BudgetEntity).toList();
  }
}