import 'package:equatable/equatable.dart';
import 'package:cashflow/features/transaction/domain/entities/transaction_with_budget.dart';
import 'package:cashflow/features/transaction/domain/entities/transaction_entity.dart';
import 'package:cashflow/features/transaction/domain/usecases/transaction_usecases.dart';
import 'package:cashflow/features/budget_management/domain/entities/category_entity.dart';

abstract class TransactionState extends Equatable {
  const TransactionState();

  @override
  List<Object?> get props => [];
}

class TransactionInitial extends TransactionState {}

class TransactionLoading extends TransactionState {}

class TransactionLoaded extends TransactionState {
  final List<TransactionWithBudget> transactions;
  final List<TransactionWithBudget> incomeTransactions;
  final List<TransactionWithBudget> expenseTransactions;
  final List<CategoryEntity> expenseCategories;
  final List<CategoryEntity> incomeCategories;
  final double totalIncome;
  final double totalExpense;
  final double balance;

  const TransactionLoaded({
    required this.transactions,
    required this.incomeTransactions,
    required this.expenseTransactions,
    required this.expenseCategories,
    required this.incomeCategories,
    required this.totalIncome,
    required this.totalExpense,
    required this.balance,
  });

  @override
  List<Object> get props => [
        transactions,
        incomeTransactions,
        expenseTransactions,
        expenseCategories,
        incomeCategories,
        totalIncome,
        totalExpense,
        balance,
      ];

  TransactionLoaded copyWith({
    List<TransactionWithBudget>? transactions,
    List<TransactionWithBudget>? incomeTransactions,
    List<TransactionWithBudget>? expenseTransactions,
    List<CategoryEntity>? expenseCategories,
    List<CategoryEntity>? incomeCategories,
    double? totalIncome,
    double? totalExpense,
    double? balance,
  }) {
    return TransactionLoaded(
      transactions: transactions ?? this.transactions,
      incomeTransactions: incomeTransactions ?? this.incomeTransactions,
      expenseTransactions: expenseTransactions ?? this.expenseTransactions,
      expenseCategories: expenseCategories ?? this.expenseCategories,
      incomeCategories: incomeCategories ?? this.incomeCategories,
      totalIncome: totalIncome ?? this.totalIncome,
      totalExpense: totalExpense ?? this.totalExpense,
      balance: balance ?? this.balance,
    );
  }
}

class TransactionError extends TransactionState {
  final String message;

  const TransactionError(this.message);

  @override
  List<Object> get props => [message];
}

class TransactionOperationSuccess extends TransactionState {
  final String message;
  final BudgetRemainingInfo? budgetInfo;

  const TransactionOperationSuccess(this.message, {this.budgetInfo});

  @override
  List<Object?> get props => [message, budgetInfo];
}

class TransactionFormState extends TransactionState {
  final TransactionType selectedType;
  final String? selectedBudgetId;
  final String title;
  final String? description;
  final double? amount;
  final DateTime selectedDate;
  final bool isLoading;
  final String? errorMessage;
  final BudgetRemainingInfo? budgetPreview;

  const TransactionFormState({
    this.selectedType = TransactionType.expense,
    this.selectedBudgetId,
    this.title = '',
    this.description,
    this.amount,
    required this.selectedDate,
    this.isLoading = false,
    this.errorMessage,
    this.budgetPreview,
  });

  @override
  List<Object?> get props => [
        selectedType,
        selectedBudgetId,
        title,
        description,
        amount,
        selectedDate,
        isLoading,
        errorMessage,
        budgetPreview,
      ];

  TransactionFormState copyWith({
    TransactionType? selectedType,
    String? selectedBudgetId,
    String? title,
    String? description,
    double? amount,
    DateTime? selectedDate,
    bool? isLoading,
    String? errorMessage,
    BudgetRemainingInfo? budgetPreview,
    bool clearBudgetPreview = false,
    bool clearError = false,
  }) {
    return TransactionFormState(
      selectedType: selectedType ?? this.selectedType,
      selectedBudgetId: selectedBudgetId ?? this.selectedBudgetId,
      title: title ?? this.title,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      selectedDate: selectedDate ?? this.selectedDate,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      budgetPreview: clearBudgetPreview ? null : (budgetPreview ?? this.budgetPreview),
    );
  }

  bool get isValid => 
    title.isNotEmpty && 
    selectedBudgetId != null && 
    amount != null && 
    amount! > 0;
}