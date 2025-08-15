import 'package:cashflow/features/budget_management/domain/entities/budget_entity.dart';


class BudgetCalculationUtils {
  
  
  
  static DateTime calculateBudgetPeriodStart(BudgetEntity budget) {
    
    return budget.createdAt;
  }

  
  
  static DateTime calculateBudgetPeriodEnd(BudgetEntity budget) {
    final now = DateTime.now();
    
    
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
    
    
    
    return periodEnd.isBefore(now) ? periodEnd : now;
  }
}