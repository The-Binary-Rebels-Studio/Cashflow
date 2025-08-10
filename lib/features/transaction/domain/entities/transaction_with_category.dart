import 'package:equatable/equatable.dart';
import 'package:cashflow/features/transaction/domain/entities/transaction_entity.dart';
import 'package:cashflow/features/budget_management/domain/entities/category_entity.dart';

class TransactionWithCategory extends Equatable {
  final TransactionEntity transaction;
  final CategoryEntity category;

  const TransactionWithCategory({
    required this.transaction,
    required this.category,
  });

  @override
  List<Object> get props => [transaction, category];
}