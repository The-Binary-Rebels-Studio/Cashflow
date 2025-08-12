import 'package:cashflow/features/budget_management/domain/entities/budget_entity.dart';

abstract class BudgetManagementEvent {
  const BudgetManagementEvent();
}

class BudgetManagementInitialized extends BudgetManagementEvent {
  const BudgetManagementInitialized();
}

class BudgetManagementDataRequested extends BudgetManagementEvent {
  const BudgetManagementDataRequested();
}

class BudgetCreateRequested extends BudgetManagementEvent {
  final String name;
  final String description;
  final String categoryId;
  final double amount;
  final BudgetPeriod period;

  const BudgetCreateRequested({
    required this.name,
    required this.description,
    required this.categoryId,
    required this.amount,
    required this.period,
  });
}

class BudgetUpdateRequested extends BudgetManagementEvent {
  final BudgetEntity budget;

  const BudgetUpdateRequested({
    required this.budget,
  });
}

class BudgetDeleteRequested extends BudgetManagementEvent {
  final String id;

  const BudgetDeleteRequested({
    required this.id,
  });
}