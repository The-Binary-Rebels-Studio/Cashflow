import 'package:cashflow/features/transaction/domain/entities/transaction_entity.dart';

abstract class TransactionEvent {
  const TransactionEvent();
}

class TransactionDataRequested extends TransactionEvent {
  const TransactionDataRequested();
}

class TransactionAddRequested extends TransactionEvent {
  final String title;
  final double amount;
  final String budgetId;
  final TransactionType type;
  final DateTime date;
  final String? description;

  const TransactionAddRequested({
    required this.title,
    required this.amount,
    required this.budgetId,
    required this.type,
    required this.date,
    this.description,
  });
}

class TransactionUpdateRequested extends TransactionEvent {
  final TransactionEntity transaction;

  const TransactionUpdateRequested({
    required this.transaction,
  });
}

class TransactionDeleteRequested extends TransactionEvent {
  final String id;

  const TransactionDeleteRequested({
    required this.id,
  });
}

class TransactionBudgetImpactPreviewRequested extends TransactionEvent {
  final String budgetId;
  final double amount;

  const TransactionBudgetImpactPreviewRequested({
    required this.budgetId,
    required this.amount,
  });
}

class TransactionFormInitialized extends TransactionEvent {
  const TransactionFormInitialized();
}

class TransactionFormTypeUpdated extends TransactionEvent {
  final TransactionType type;

  const TransactionFormTypeUpdated({
    required this.type,
  });
}

class TransactionFormBudgetUpdated extends TransactionEvent {
  final String budgetId;

  const TransactionFormBudgetUpdated({
    required this.budgetId,
  });
}

class TransactionFormTitleUpdated extends TransactionEvent {
  final String title;

  const TransactionFormTitleUpdated({
    required this.title,
  });
}

class TransactionFormDescriptionUpdated extends TransactionEvent {
  final String description;

  const TransactionFormDescriptionUpdated({
    required this.description,
  });
}

class TransactionFormAmountUpdated extends TransactionEvent {
  final double amount;

  const TransactionFormAmountUpdated({
    required this.amount,
  });
}

class TransactionFormDateUpdated extends TransactionEvent {
  final DateTime date;

  const TransactionFormDateUpdated({
    required this.date,
  });
}

class TransactionFormSubmitted extends TransactionEvent {
  const TransactionFormSubmitted();
}

class TransactionFormErrorCleared extends TransactionEvent {
  const TransactionFormErrorCleared();
}

class TransactionFormReset extends TransactionEvent {
  const TransactionFormReset();
}