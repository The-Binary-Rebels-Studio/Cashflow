import 'package:equatable/equatable.dart';
import 'package:cashflow/features/budget_management/domain/entities/category_entity.dart';

class TransactionEntity extends Equatable {
  final String id;
  final String title;
  final String? description;
  final double amount;
  final String categoryId;
  final TransactionType type;
  final DateTime date;
  final DateTime createdAt;
  final DateTime updatedAt;

  const TransactionEntity({
    required this.id,
    required this.title,
    this.description,
    required this.amount,
    required this.categoryId,
    required this.type,
    required this.date,
    required this.createdAt,
    required this.updatedAt,
  });

  TransactionEntity copyWith({
    String? id,
    String? title,
    String? description,
    double? amount,
    String? categoryId,
    TransactionType? type,
    DateTime? date,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TransactionEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      categoryId: categoryId ?? this.categoryId,
      type: type ?? this.type,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get isIncome => type == TransactionType.income;
  bool get isExpense => type == TransactionType.expense;
  double get absoluteAmount => amount.abs();

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        amount,
        categoryId,
        type,
        date,
        createdAt,
        updatedAt,
      ];
}

enum TransactionType {
  income('income'),
  expense('expense');

  const TransactionType(this.value);
  final String value;

  static TransactionType fromString(String value) {
    switch (value) {
      case 'income':
        return TransactionType.income;
      case 'expense':
        return TransactionType.expense;
      default:
        throw ArgumentError('Invalid transaction type: $value');
    }
  }

  static TransactionType fromCategoryType(CategoryType categoryType) {
    switch (categoryType) {
      case CategoryType.income:
        return TransactionType.income;
      case CategoryType.expense:
        return TransactionType.expense;
    }
  }
}