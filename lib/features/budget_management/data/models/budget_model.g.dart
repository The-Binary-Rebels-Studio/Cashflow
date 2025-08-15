// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BudgetModel _$BudgetModelFromJson(Map<String, dynamic> json) => BudgetModel(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String,
  categoryId: json['categoryId'] as String,
  amount: (json['amount'] as num).toDouble(),
  period: $enumDecode(_$BudgetPeriodEnumMap, json['period']),
  startDate: DateTime.parse(json['startDate'] as String),
  endDate: DateTime.parse(json['endDate'] as String),
  isActive: json['isActive'] as bool? ?? true,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$BudgetModelToJson(BudgetModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'categoryId': instance.categoryId,
      'amount': instance.amount,
      'period': _$BudgetPeriodEnumMap[instance.period]!,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'isActive': instance.isActive,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$BudgetPeriodEnumMap = {
  BudgetPeriod.weekly: 'weekly',
  BudgetPeriod.monthly: 'monthly',
  BudgetPeriod.quarterly: 'quarterly',
  BudgetPeriod.yearly: 'yearly',
};
