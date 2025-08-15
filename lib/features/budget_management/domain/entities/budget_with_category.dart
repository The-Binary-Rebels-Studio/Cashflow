import 'package:equatable/equatable.dart';
import 'budget_entity.dart';
import 'category_entity.dart';

class BudgetWithCategory extends Equatable {
  final BudgetEntity budget;
  final CategoryEntity category;
  
  const BudgetWithCategory({
    required this.budget,
    required this.category,
  });

  @override
  List<Object> get props => [budget, category];

  
  String get id => budget.id;
  String get name => budget.name;
  String get description => budget.description;
  double get amount => budget.amount;
  BudgetPeriod get period => budget.period;
  DateTime get startDate => budget.startDate;
  DateTime get endDate => budget.endDate;
  bool get isActive => budget.isActive;
  
  String get categoryName => category.name;
  String get categoryIconCodePoint => category.iconCodePoint;
  String get categoryColorValue => category.colorValue;
  CategoryType get categoryType => category.type;

  BudgetWithCategory copyWith({
    BudgetEntity? budget,
    CategoryEntity? category,
  }) {
    return BudgetWithCategory(
      budget: budget ?? this.budget,
      category: category ?? this.category,
    );
  }
}