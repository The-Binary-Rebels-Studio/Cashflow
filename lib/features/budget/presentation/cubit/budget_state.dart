import 'package:equatable/equatable.dart';
import '../../domain/entities/budget_entity.dart';

abstract class BudgetState extends Equatable {
  const BudgetState();

  @override
  List<Object> get props => [];
}

class BudgetInitial extends BudgetState {}

class BudgetLoading extends BudgetState {}

class BudgetLoaded extends BudgetState {
  final List<BudgetEntity> budgets;
  final List<BudgetEntity> activeBudgets;
  final List<BudgetEntity> currentPeriodBudgets;

  const BudgetLoaded({
    required this.budgets,
    required this.activeBudgets,
    required this.currentPeriodBudgets,
  });

  @override
  List<Object> get props => [budgets, activeBudgets, currentPeriodBudgets];
}

class BudgetError extends BudgetState {
  final String message;

  const BudgetError(this.message);

  @override
  List<Object> get props => [message];
}

class BudgetOperationSuccess extends BudgetState {
  final String message;

  const BudgetOperationSuccess(this.message);

  @override
  List<Object> get props => [message];
}