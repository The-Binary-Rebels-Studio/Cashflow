import 'package:equatable/equatable.dart';

class BudgetEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final String categoryId;
  final double amount;
  final BudgetPeriod period;
  final DateTime startDate;
  final DateTime endDate;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const BudgetEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.categoryId,
    required this.amount,
    required this.period,
    required this.startDate,
    required this.endDate,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  BudgetEntity copyWith({
    String? id,
    String? name,
    String? description,
    String? categoryId,
    double? amount,
    BudgetPeriod? period,
    DateTime? startDate,
    DateTime? endDate,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BudgetEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      categoryId: categoryId ?? this.categoryId,
      amount: amount ?? this.amount,
      period: period ?? this.period,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object> get props => [
        id,
        name,
        description,
        categoryId,
        amount,
        period,
        startDate,
        endDate,
        isActive,
        createdAt,
        updatedAt,
      ];
}

enum BudgetPeriod {
  weekly('weekly'),
  monthly('monthly'),
  quarterly('quarterly'),
  yearly('yearly');

  const BudgetPeriod(this.value);
  final String value;

  static BudgetPeriod fromString(String value) {
    switch (value) {
      case 'weekly':
        return BudgetPeriod.weekly;
      case 'monthly':
        return BudgetPeriod.monthly;
      case 'quarterly':
        return BudgetPeriod.quarterly;
      case 'yearly':
        return BudgetPeriod.yearly;
      default:
        throw ArgumentError('Invalid budget period: $value');
    }
  }

  String get displayName {
    switch (this) {
      case BudgetPeriod.weekly:
        return 'Weekly';
      case BudgetPeriod.monthly:
        return 'Monthly';
      case BudgetPeriod.quarterly:
        return 'Quarterly';
      case BudgetPeriod.yearly:
        return 'Yearly';
    }
  }

  Duration get duration {
    switch (this) {
      case BudgetPeriod.weekly:
        return const Duration(days: 7);
      case BudgetPeriod.monthly:
        return const Duration(days: 30);
      case BudgetPeriod.quarterly:
        return const Duration(days: 90);
      case BudgetPeriod.yearly:
        return const Duration(days: 365);
    }
  }
}