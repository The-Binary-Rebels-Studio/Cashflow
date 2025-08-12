import 'package:equatable/equatable.dart';
import 'package:cashflow/features/transaction/domain/entities/transaction_entity.dart';
import 'package:cashflow/features/budget_management/domain/entities/budget_entity.dart';
import 'package:cashflow/features/budget_management/domain/entities/category_entity.dart';

class TransactionWithBudgetAndCategory extends Equatable {
  final TransactionEntity transaction;
  final BudgetEntity budget;
  final CategoryEntity category;

  const TransactionWithBudgetAndCategory({
    required this.transaction,
    required this.budget,
    required this.category,
  });

  @override
  List<Object> get props => [transaction, budget, category];
}