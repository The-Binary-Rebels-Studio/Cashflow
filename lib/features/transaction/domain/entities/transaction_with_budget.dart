import 'package:equatable/equatable.dart';
import 'package:cashflow/features/transaction/domain/entities/transaction_entity.dart';
import 'package:cashflow/features/budget_management/domain/entities/budget_entity.dart';

class TransactionWithBudget extends Equatable {
  final TransactionEntity transaction;
  final BudgetEntity budget;

  const TransactionWithBudget({
    required this.transaction,
    required this.budget,
  });

  @override
  List<Object> get props => [transaction, budget];
}