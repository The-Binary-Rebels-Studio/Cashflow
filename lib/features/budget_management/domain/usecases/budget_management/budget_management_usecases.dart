import 'package:injectable/injectable.dart';
import 'package:cashflow/features/budget_management/domain/entities/category_entity.dart';
import 'package:cashflow/features/budget_management/domain/entities/budget_entity.dart';
import 'package:cashflow/features/budget_management/domain/repositories/budget_management_repository.dart';

@injectable
class GetBudgetCategories {
  final BudgetManagementRepository _repository;

  GetBudgetCategories(this._repository);

  Future<List<CategoryEntity>> call() async {
    return await _repository.getAllCategories();
  }
}

@injectable
class GetExpenseBudgetCategories {
  final BudgetManagementRepository _repository;

  GetExpenseBudgetCategories(this._repository);

  Future<List<CategoryEntity>> call() async {
    return await _repository.getCategoriesByType(CategoryType.expense);
  }
}

@injectable
class GetIncomeBudgetCategories {
  final BudgetManagementRepository _repository;

  GetIncomeBudgetCategories(this._repository);

  Future<List<CategoryEntity>> call() async {
    return await _repository.getCategoriesByType(CategoryType.income);
  }
}

@injectable
class GetBudgetPlans {
  final BudgetManagementRepository _repository;

  GetBudgetPlans(this._repository);

  Future<List<BudgetEntity>> call() async {
    return await _repository.getAllBudgets();
  }
}

@injectable
class GetActiveBudgetPlans {
  final BudgetManagementRepository _repository;

  GetActiveBudgetPlans(this._repository);

  Future<List<BudgetEntity>> call() async {
    return await _repository.getActiveBudgets();
  }
}

@injectable
class GetBudgetsByCategory {
  final BudgetManagementRepository _repository;

  GetBudgetsByCategory(this._repository);

  Future<Map<CategoryEntity, List<BudgetEntity>>> call() async {
    return await _repository.getBudgetsGroupedByCategory();
  }
}

@injectable
class GetBudgetSummary {
  final BudgetManagementRepository _repository;

  GetBudgetSummary(this._repository);

  Future<Map<String, double>> call() async {
    return await _repository.getCategoryBudgetSummary();
  }
}

@injectable
class CreateBudgetPlan {
  final BudgetManagementRepository _repository;

  CreateBudgetPlan(this._repository);

  Future<String> call({
    required String name,
    required String description,
    required String categoryId,
    required double amount,
    required BudgetPeriod period,
  }) async {
    final now = DateTime.now();
    final budget = BudgetEntity(
      id: _generateId(),
      name: name,
      description: description,
      categoryId: categoryId,
      amount: amount,
      period: period,
      startDate: now,
      endDate: _calculateEndDate(now, period),
      isActive: true,
      createdAt: now,
      updatedAt: now,
    );
    
    return await _repository.createBudget(budget);
  }

  String _generateId() {
    return 'budget_${DateTime.now().millisecondsSinceEpoch}_${(DateTime.now().microsecond % 1000)}';
  }

  DateTime _calculateEndDate(DateTime startDate, BudgetPeriod period) {
    switch (period) {
      case BudgetPeriod.weekly:
        return startDate.add(const Duration(days: 7));
      case BudgetPeriod.monthly:
        return DateTime(startDate.year, startDate.month + 1, startDate.day);
      case BudgetPeriod.quarterly:
        return DateTime(startDate.year, startDate.month + 3, startDate.day);
      case BudgetPeriod.yearly:
        return DateTime(startDate.year + 1, startDate.month, startDate.day);
    }
  }
}

@injectable
class UpdateBudgetPlan {
  final BudgetManagementRepository _repository;

  UpdateBudgetPlan(this._repository);

  Future<void> call(BudgetEntity budget) async {
    await _repository.updateBudget(budget);
  }
}

@injectable
class DeleteBudgetPlan {
  final BudgetManagementRepository _repository;

  DeleteBudgetPlan(this._repository);

  Future<void> call(String id) async {
    await _repository.deleteBudget(id);
  }
}

@injectable
class InitializeBudgetCategories {
  final BudgetManagementRepository _repository;

  InitializeBudgetCategories(this._repository);

  Future<void> call() async {
    await _repository.initializePredefinedCategories();
  }
}