import 'package:cashflow/features/budget_management/domain/entities/budget_entity.dart';

/// Utility functions for budget-specific period calculations
class BudgetCalculationUtils {
  /// Calculate budget-specific period start (from budget creation date)
  /// This ensures new budgets don't inherit transactions from previous budgets
  /// with the same category
  static DateTime calculateBudgetPeriodStart(BudgetEntity budget) {
    // Start from when the budget was created, not from rolling calendar periods
    return budget.createdAt;
  }

  /// Calculate budget-specific period end (current date or budget period end)
  /// This ensures we don't count future transactions but respect the budget period
  static DateTime calculateBudgetPeriodEnd(BudgetEntity budget) {
    final now = DateTime.now();
    
    // Calculate the theoretical period end based on creation date and period type
    final creationDate = budget.createdAt;
    DateTime periodEnd;
    
    switch (budget.period) {
      case BudgetPeriod.weekly:
        periodEnd = creationDate.add(const Duration(days: 7));
        break;
      case BudgetPeriod.monthly:
        periodEnd = DateTime(creationDate.year, creationDate.month + 1, creationDate.day);
        break;
      case BudgetPeriod.quarterly:
        periodEnd = DateTime(creationDate.year, creationDate.month + 3, creationDate.day);
        break;
      case BudgetPeriod.yearly:
        periodEnd = DateTime(creationDate.year + 1, creationDate.month, creationDate.day);
        break;
    }
    
    // Return the earlier of: theoretical period end OR current date
    // This ensures we don't count future transactions but respect the budget period
    return periodEnd.isBefore(now) ? periodEnd : now;
  }
}