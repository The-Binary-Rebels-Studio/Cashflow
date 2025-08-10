import 'package:injectable/injectable.dart';
import 'package:cashflow/core/error/result.dart';
import 'package:cashflow/core/error/failures.dart';
import 'package:cashflow/features/budget_management/domain/entities/category_entity.dart';
import 'package:cashflow/features/budget_management/domain/entities/budget_entity.dart';
import 'package:cashflow/features/budget_management/domain/repositories/budget_management_repository.dart';

@injectable
class GetBudgetCategories {
  final BudgetManagementRepository _repository;

  GetBudgetCategories(this._repository);

  Future<Result<List<CategoryEntity>>> call() async {
    try {
      final categories = await _repository.getAllCategories();
      return success(categories);
    } catch (e, stackTrace) {
      return failure(CategoryFailure(
        message: 'Failed to get budget categories: ${e.toString()}',
        originalError: e,
        stackTrace: stackTrace,
      ));
    }
  }
}

@injectable
class GetExpenseBudgetCategories {
  final BudgetManagementRepository _repository;

  GetExpenseBudgetCategories(this._repository);

  Future<Result<List<CategoryEntity>>> call() async {
    try {
      final categories = await _repository.getCategoriesByType(CategoryType.expense);
      return success(categories);
    } catch (e, stackTrace) {
      return failure(CategoryFailure(
        message: 'Failed to get expense categories: ${e.toString()}',
        originalError: e,
        stackTrace: stackTrace,
      ));
    }
  }
}

@injectable
class GetIncomeBudgetCategories {
  final BudgetManagementRepository _repository;

  GetIncomeBudgetCategories(this._repository);

  Future<Result<List<CategoryEntity>>> call() async {
    try {
      final categories = await _repository.getCategoriesByType(CategoryType.income);
      return success(categories);
    } catch (e, stackTrace) {
      return failure(CategoryFailure(
        message: 'Failed to get income categories: ${e.toString()}',
        originalError: e,
        stackTrace: stackTrace,
      ));
    }
  }
}

@injectable
class GetBudgetPlans {
  final BudgetManagementRepository _repository;

  GetBudgetPlans(this._repository);

  Future<Result<List<BudgetEntity>>> call() async {
    try {
      final budgets = await _repository.getAllBudgets();
      return success(budgets);
    } catch (e, stackTrace) {
      return failure(BudgetFailure(
        message: 'Failed to get budget plans: ${e.toString()}',
        originalError: e,
        stackTrace: stackTrace,
      ));
    }
  }
}

@injectable
class GetActiveBudgetPlans {
  final BudgetManagementRepository _repository;

  GetActiveBudgetPlans(this._repository);

  Future<Result<List<BudgetEntity>>> call() async {
    try {
      final budgets = await _repository.getActiveBudgets();
      return success(budgets);
    } catch (e, stackTrace) {
      return failure(BudgetFailure(
        message: 'Failed to get active budget plans: ${e.toString()}',
        originalError: e,
        stackTrace: stackTrace,
      ));
    }
  }
}

@injectable
class GetBudgetsByCategory {
  final BudgetManagementRepository _repository;

  GetBudgetsByCategory(this._repository);

  Future<Result<Map<CategoryEntity, List<BudgetEntity>>>> call() async {
    try {
      final budgetsByCategory = await _repository.getBudgetsGroupedByCategory();
      return success(budgetsByCategory);
    } catch (e, stackTrace) {
      return failure(BudgetFailure(
        message: 'Failed to get budgets by category: ${e.toString()}',
        originalError: e,
        stackTrace: stackTrace,
      ));
    }
  }
}

@injectable
class GetBudgetSummary {
  final BudgetManagementRepository _repository;

  GetBudgetSummary(this._repository);

  Future<Result<Map<String, double>>> call() async {
    try {
      final summary = await _repository.getCategoryBudgetSummary();
      return success(summary);
    } catch (e, stackTrace) {
      return failure(BudgetFailure(
        message: 'Failed to get budget summary: ${e.toString()}',
        originalError: e,
        stackTrace: stackTrace,
      ));
    }
  }
}

@injectable
class CreateBudgetPlan {
  final BudgetManagementRepository _repository;

  CreateBudgetPlan(this._repository);

  Future<Result<String>> call({
    required String name,
    required String description,
    required String categoryId,
    required double amount,
    required BudgetPeriod period,
  }) async {
    try {
      // Validation
      if (name.trim().isEmpty) {
        return failure(ValidationFailure(
          message: 'Budget name cannot be empty',
          fieldErrors: {'name': ['Budget name is required']},
        ));
      }
      
      if (amount <= 0) {
        return failure(ValidationFailure(
          message: 'Budget amount must be greater than 0',
          fieldErrors: {'amount': ['Amount must be greater than 0']},
        ));
      }
      
      final now = DateTime.now();
      final startDate = _calculateStartDate(now, period);
      final budget = BudgetEntity(
        id: _generateId(),
        name: name,
        description: description,
        categoryId: categoryId,
        amount: amount,
        period: period,
        startDate: startDate,
        endDate: _calculateEndDate(startDate, period),
        isActive: true,
        createdAt: now,
        updatedAt: now,
      );
      
      final budgetId = await _repository.createBudget(budget);
      return success(budgetId);
    } catch (e, stackTrace) {
      return failure(BudgetFailure(
        message: 'Failed to create budget plan: ${e.toString()}',
        originalError: e,
        stackTrace: stackTrace,
      ));
    }
  }

  String _generateId() {
    return 'budget_${DateTime.now().millisecondsSinceEpoch}_${(DateTime.now().microsecond % 1000)}';
  }

  /// Calculate start date - always starts at the beginning of the period
  DateTime _calculateStartDate(DateTime currentDate, BudgetPeriod period) {
    switch (period) {
      case BudgetPeriod.weekly:
        // Start of current week (Monday)
        final weekday = currentDate.weekday;
        return currentDate.subtract(Duration(days: weekday - 1));
      case BudgetPeriod.monthly:
        // Start of current month
        return DateTime(currentDate.year, currentDate.month, 1);
      case BudgetPeriod.quarterly:
        // Start of current quarter
        final quarterStartMonth = ((currentDate.month - 1) ~/ 3) * 3 + 1;
        return DateTime(currentDate.year, quarterStartMonth, 1);
      case BudgetPeriod.yearly:
        // Start of current year
        return DateTime(currentDate.year, 1, 1);
    }
  }

  DateTime _calculateEndDate(DateTime startDate, BudgetPeriod period) {
    switch (period) {
      case BudgetPeriod.weekly:
        return startDate.add(const Duration(days: 6)); // Sunday of the same week
      case BudgetPeriod.monthly:
        return DateTime(startDate.year, startDate.month + 1, 1).subtract(const Duration(days: 1)); // Last day of month
      case BudgetPeriod.quarterly:
        return DateTime(startDate.year, startDate.month + 3, 1).subtract(const Duration(days: 1)); // Last day of quarter
      case BudgetPeriod.yearly:
        return DateTime(startDate.year, 12, 31); // Last day of year
    }
  }
}

@injectable
class UpdateBudgetPlan {
  final BudgetManagementRepository _repository;

  UpdateBudgetPlan(this._repository);

  Future<Result<void>> call(BudgetEntity budget) async {
    try {
      // Validation
      final validationResult = _validateBudget(budget);
      if (validationResult.isFailure) {
        return failure(validationResult.failure!);
      }
      
      await _repository.updateBudget(budget);
      return success(null);
    } catch (e, stackTrace) {
      return failure(BudgetFailure(
        message: 'Failed to update budget plan: ${e.toString()}',
        originalError: e,
        stackTrace: stackTrace,
      ));
    }
  }

  /// Validates budget entity
  Result<void> _validateBudget(BudgetEntity budget) {
    final Map<String, List<String>> fieldErrors = {};
    
    if (budget.name.trim().isEmpty) {
      fieldErrors['name'] = ['Budget name is required'];
    }
    
    if (budget.amount <= 0) {
      fieldErrors['amount'] = ['Budget amount must be greater than 0'];
    }
    
    if (budget.categoryId.trim().isEmpty) {
      fieldErrors['categoryId'] = ['Category selection is required'];
    }
    
    if (fieldErrors.isNotEmpty) {
      return failure(ValidationFailure(
        message: 'Budget validation failed',
        fieldErrors: fieldErrors,
      ));
    }
    
    return success(null);
  }
}

@injectable
class DeleteBudgetPlan {
  final BudgetManagementRepository _repository;

  DeleteBudgetPlan(this._repository);

  Future<Result<void>> call(String id) async {
    try {
      if (id.trim().isEmpty) {
        return failure(ValidationFailure(
          message: 'Budget ID cannot be empty',
          fieldErrors: {'id': ['Budget ID is required']},
        ));
      }
      
      await _repository.deleteBudget(id);
      return success(null);
    } catch (e, stackTrace) {
      return failure(BudgetFailure(
        message: 'Failed to delete budget plan: ${e.toString()}',
        originalError: e,
        stackTrace: stackTrace,
      ));
    }
  }
}

@injectable
class InitializeBudgetCategories {
  final BudgetManagementRepository _repository;

  InitializeBudgetCategories(this._repository);

  Future<Result<void>> call() async {
    try {
      await _repository.initializePredefinedCategories();
      return success(null);
    } catch (e, stackTrace) {
      return failure(CategoryFailure(
        message: 'Failed to initialize budget categories: ${e.toString()}',
        originalError: e,
        stackTrace: stackTrace,
      ));
    }
  }
}