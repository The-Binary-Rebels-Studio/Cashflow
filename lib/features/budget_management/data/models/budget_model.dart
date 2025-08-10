import 'package:cashflow/features/budget_management/domain/entities/budget_entity.dart';

class BudgetModel extends BudgetEntity {
  const BudgetModel({
    required super.id,
    required super.name,
    required super.description,
    required super.categoryId,
    required super.amount,
    required super.period,
    required super.startDate,
    required super.endDate,
    super.isActive = true,
    required super.createdAt,
    required super.updatedAt,
  });

  factory BudgetModel.fromMap(Map<String, dynamic> map) {
    return BudgetModel(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String? ?? '',
      categoryId: map['category_id'] as String,
      amount: (map['amount'] as num).toDouble(),
      period: BudgetPeriod.fromString(map['period'] as String),
      startDate: DateTime.parse(map['start_date'] as String),
      endDate: DateTime.parse(map['end_date'] as String),
      isActive: (map['is_active'] as int) == 1,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  factory BudgetModel.fromEntity(BudgetEntity entity) {
    return BudgetModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      categoryId: entity.categoryId,
      amount: entity.amount,
      period: entity.period,
      startDate: entity.startDate,
      endDate: entity.endDate,
      isActive: entity.isActive,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category_id': categoryId,
      'amount': amount,
      'period': period.value,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'is_active': isActive ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  @override
  BudgetModel copyWith({
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
    return BudgetModel(
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

  /// Check if this budget is currently active (within date range)
  bool get isCurrentlyActive {
    final now = DateTime.now();
    return isActive && 
           now.isAfter(startDate) && 
           now.isBefore(endDate);
  }

  /// Get progress percentage (0.0 to 1.0)
  /// This would require spent amount from transactions
  double getProgress(double spentAmount) {
    if (amount <= 0) return 0.0;
    return (spentAmount / amount).clamp(0.0, 1.0);
  }

  /// Get remaining amount
  double getRemainingAmount(double spentAmount) {
    return (amount - spentAmount).clamp(0.0, amount);
  }

  /// Check if budget is exceeded
  bool isExceeded(double spentAmount) {
    return spentAmount > amount;
  }
}