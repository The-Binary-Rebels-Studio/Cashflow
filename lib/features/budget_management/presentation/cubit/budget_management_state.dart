import 'package:equatable/equatable.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/budget_entity.dart';

abstract class BudgetManagementState extends Equatable {
  const BudgetManagementState();

  @override
  List<Object> get props => [];
}

class BudgetManagementInitial extends BudgetManagementState {}

class BudgetManagementLoading extends BudgetManagementState {}

class BudgetManagementLoaded extends BudgetManagementState {
  final List<CategoryEntity> categories;
  final List<CategoryEntity> expenseCategories;
  final List<CategoryEntity> incomeCategories;
  final List<BudgetEntity> budgetPlans;
  final List<BudgetEntity> activeBudgetPlans;
  final Map<CategoryEntity, List<BudgetEntity>> budgetsByCategory;
  final Map<String, double> budgetSummary;

  const BudgetManagementLoaded({
    required this.categories,
    required this.expenseCategories,
    required this.incomeCategories,
    required this.budgetPlans,
    required this.activeBudgetPlans,
    required this.budgetsByCategory,
    required this.budgetSummary,
  });

  @override
  List<Object> get props => [
        categories,
        expenseCategories,
        incomeCategories,
        budgetPlans,
        activeBudgetPlans,
        budgetsByCategory,
        budgetSummary,
      ];

  BudgetManagementLoaded copyWith({
    List<CategoryEntity>? categories,
    List<CategoryEntity>? expenseCategories,
    List<CategoryEntity>? incomeCategories,
    List<BudgetEntity>? budgetPlans,
    List<BudgetEntity>? activeBudgetPlans,
    Map<CategoryEntity, List<BudgetEntity>>? budgetsByCategory,
    Map<String, double>? budgetSummary,
  }) {
    return BudgetManagementLoaded(
      categories: categories ?? this.categories,
      expenseCategories: expenseCategories ?? this.expenseCategories,
      incomeCategories: incomeCategories ?? this.incomeCategories,
      budgetPlans: budgetPlans ?? this.budgetPlans,
      activeBudgetPlans: activeBudgetPlans ?? this.activeBudgetPlans,
      budgetsByCategory: budgetsByCategory ?? this.budgetsByCategory,
      budgetSummary: budgetSummary ?? this.budgetSummary,
    );
  }
}

class BudgetManagementError extends BudgetManagementState {
  final String message;

  const BudgetManagementError(this.message);

  @override
  List<Object> get props => [message];
}

class BudgetManagementOperationSuccess extends BudgetManagementState {
  final String message;

  const BudgetManagementOperationSuccess(this.message);

  @override
  List<Object> get props => [message];
}