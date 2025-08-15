import 'package:flutter/foundation.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:cashflow/features/budget_management/domain/entities/budget_entity.dart';

part 'budget_model.g.dart';

@JsonSerializable()
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

  factory BudgetModel.fromJson(Map<String, dynamic> json) => _$BudgetModelFromJson(json);

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

  Map<String, dynamic> toJson() => _$BudgetModelToJson(this);

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

  
  
  bool get isCurrentlyActive {
    return isActive;
  }

  
  DateTime getCurrentPeriodStart([DateTime? referenceDate]) {
    final now = referenceDate ?? DateTime.now();
    
    DateTime result;
    switch (period) {
      case BudgetPeriod.weekly:
        
        final weekday = now.weekday;
        result = DateTime(now.year, now.month, now.day).subtract(Duration(days: weekday - 1));
        break;
      case BudgetPeriod.monthly:
        
        result = DateTime(now.year, now.month, 1);
        break;
      case BudgetPeriod.quarterly:
        
        final quarterStartMonth = ((now.month - 1) ~/ 3) * 3 + 1;
        result = DateTime(now.year, quarterStartMonth, 1);
        break;
      case BudgetPeriod.yearly:
        
        result = DateTime(now.year, 1, 1);
        break;
    }
    
    
    
    return result;
  }

  
  DateTime _calculateCurrentPeriodStart(DateTime now) {
    switch (period) {
      case BudgetPeriod.weekly:
        final weekday = now.weekday;
        return DateTime(now.year, now.month, now.day).subtract(Duration(days: weekday - 1));
      case BudgetPeriod.monthly:
        return DateTime(now.year, now.month, 1);
      case BudgetPeriod.quarterly:
        final quarterStartMonth = ((now.month - 1) ~/ 3) * 3 + 1;
        return DateTime(now.year, quarterStartMonth, 1);
      case BudgetPeriod.yearly:
        return DateTime(now.year, 1, 1);
    }
  }

  
  DateTime _calculateCurrentPeriodEnd(DateTime now) {
    final currentStart = _calculateCurrentPeriodStart(now);
    
    switch (period) {
      case BudgetPeriod.weekly:
        return currentStart.add(const Duration(days: 6));
      case BudgetPeriod.monthly:
        return DateTime(currentStart.year, currentStart.month + 1, 1).subtract(const Duration(days: 1));
      case BudgetPeriod.quarterly:
        return DateTime(currentStart.year, currentStart.month + 3, 1).subtract(const Duration(days: 1));
      case BudgetPeriod.yearly:
        return DateTime(currentStart.year, 12, 31);
    }
  }

  
  DateTime getCurrentPeriodEnd([DateTime? referenceDate]) {
    final now = referenceDate ?? DateTime.now();
    return _calculateCurrentPeriodEnd(now);
  }

  
  
  double getProgress(double spentAmount) {
    if (amount <= 0) return 0.0;
    return (spentAmount / amount).clamp(0.0, 1.0);
  }

  
  double getRemainingAmount(double spentAmount) {
    return (amount - spentAmount).clamp(0.0, amount);
  }

  
  bool isExceeded(double spentAmount) {
    return spentAmount > amount;
  }
}