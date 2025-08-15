import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:cashflow/core/error/failures.dart';
import 'package:cashflow/features/transaction/domain/entities/transaction_entity.dart';
import 'package:cashflow/features/transaction/domain/entities/transaction_with_budget.dart';
import 'package:cashflow/features/transaction/domain/usecases/transaction_usecases.dart';
import 'package:cashflow/features/budget_management/domain/entities/category_entity.dart';
import 'package:cashflow/features/budget_management/domain/repositories/budget_management_repository.dart';
import 'package:cashflow/features/transaction/presentation/bloc/transaction_event.dart';
import 'package:cashflow/features/transaction/presentation/bloc/transaction_state.dart';

@injectable
class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final TransactionUsecases transactionUsecases;
  final BudgetManagementRepository budgetManagementRepository;

  TransactionBloc(
    this.transactionUsecases,
    this.budgetManagementRepository,
  ) : super(TransactionInitial()) {
    on<TransactionDataRequested>(_onDataRequested);
    on<TransactionAddRequested>(_onAddRequested);
    on<TransactionUpdateRequested>(_onUpdateRequested);
    on<TransactionDeleteRequested>(_onDeleteRequested);
    on<TransactionBudgetImpactPreviewRequested>(_onBudgetImpactPreviewRequested);
    on<TransactionFormInitialized>(_onFormInitialized);
    on<TransactionFormTypeUpdated>(_onFormTypeUpdated);
    on<TransactionFormBudgetUpdated>(_onFormBudgetUpdated);
    on<TransactionFormTitleUpdated>(_onFormTitleUpdated);
    on<TransactionFormDescriptionUpdated>(_onFormDescriptionUpdated);
    on<TransactionFormAmountUpdated>(_onFormAmountUpdated);
    on<TransactionFormDateUpdated>(_onFormDateUpdated);
    on<TransactionFormSubmitted>(_onFormSubmitted);
    on<TransactionFormErrorCleared>(_onFormErrorCleared);
    on<TransactionFormReset>(_onFormReset);
  }

  Future<void> _onDataRequested(
    TransactionDataRequested event,
    Emitter<TransactionState> emit,
  ) async {
    emit(TransactionLoading());
    
    
    final results = await Future.wait([
      transactionUsecases.getAllTransactions(),
      transactionUsecases.getTransactionsByType(TransactionType.income),
      transactionUsecases.getTransactionsByType(TransactionType.expense),
      transactionUsecases.getTotalByType(TransactionType.income),
      transactionUsecases.getTotalByType(TransactionType.expense),
    ]);
    
    
    for (final result in results) {
      if (result.isFailure) {
        emit(TransactionError(_getErrorMessage(result.failure!)));
        return;
      }
    }
    
    try {
      
      final transactions = results[0].value as List<TransactionWithBudget>;
      final incomeTransactions = results[1].value as List<TransactionWithBudget>;
      final expenseTransactions = results[2].value as List<TransactionWithBudget>;
      final totalIncome = results[3].value as double;
      final totalExpense = results[4].value as double;
      
      final balance = totalIncome + totalExpense; 
      
      final expenseCategories = await budgetManagementRepository.getCategoriesByType(CategoryType.expense);
      final incomeCategories = await budgetManagementRepository.getCategoriesByType(CategoryType.income);

      emit(TransactionLoaded(
        transactions: transactions,
        incomeTransactions: incomeTransactions,
        expenseTransactions: expenseTransactions,
        expenseCategories: expenseCategories,
        incomeCategories: incomeCategories,
        totalIncome: totalIncome,
        totalExpense: totalExpense.abs(), 
        balance: balance, 
      ));
    } catch (e) {
      emit(TransactionError('Failed to process transaction data: ${e.toString()}'));
    }
  }

  Future<void> _onAddRequested(
    TransactionAddRequested event,
    Emitter<TransactionState> emit,
  ) async {
    try {
      final currentState = state;
      if (currentState is TransactionLoaded) {
        emit(currentState.copyWith());
      } else {
        emit(TransactionLoading());
      }

      final now = DateTime.now();
      final transaction = TransactionEntity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: event.title,
        description: event.description,
        amount: event.type == TransactionType.income ? event.amount : -event.amount,
        budgetId: event.budgetId,
        type: event.type,
        date: event.date,
        createdAt: now,
        updatedAt: now,
      );

      BudgetRemainingInfo? budgetInfo;
      if (event.type == TransactionType.expense) {
        final budgetResult = await transactionUsecases.calculateRemainingBudgetAfterExpense(
          event.budgetId,
          event.amount,
        );
        
        budgetResult.fold(
          onSuccess: (info) => budgetInfo = info,
          onFailure: (_) => budgetInfo = null, 
        );
      }

      final addResult = await transactionUsecases.addTransaction(transaction);
      
      if (addResult.isFailure) {
        emit(TransactionError(_getErrorMessage(addResult.failure!)));
        return;
      }
      
      emit(TransactionOperationSuccess(
        event.type == TransactionType.income 
          ? 'Income added successfully!' 
          : 'Expense added successfully!',
        budgetInfo: budgetInfo,
      ));

      add(const TransactionDataRequested());
    } catch (e) {
      emit(TransactionError('Failed to add transaction: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateRequested(
    TransactionUpdateRequested event,
    Emitter<TransactionState> emit,
  ) async {
    try {
      await transactionUsecases.updateTransaction(event.transaction);
      emit(const TransactionOperationSuccess('Transaction updated successfully!'));
      add(const TransactionDataRequested());
    } catch (e) {
      emit(TransactionError('Failed to update transaction: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteRequested(
    TransactionDeleteRequested event,
    Emitter<TransactionState> emit,
  ) async {
    try {
      await transactionUsecases.deleteTransaction(event.id);
      emit(const TransactionOperationSuccess('Transaction deleted successfully!'));
      add(const TransactionDataRequested());
    } catch (e) {
      emit(TransactionError('Failed to delete transaction: ${e.toString()}'));
    }
  }

  Future<void> _onBudgetImpactPreviewRequested(
    TransactionBudgetImpactPreviewRequested event,
    Emitter<TransactionState> emit,
  ) async {
    if (event.amount <= 0) return;
    
    try {
      final budgetResult = await transactionUsecases.calculateRemainingBudgetAfterExpense(
        event.budgetId,
        event.amount,
      );
      
      final currentState = state;
      if (currentState is TransactionFormState) {
        budgetResult.fold(
          onSuccess: (budgetInfo) {
            emit(currentState.copyWith(budgetPreview: budgetInfo));
          },
          onFailure: (_) {
            
            emit(currentState.copyWith(budgetPreview: null));
          },
        );
      }
    } catch (e) {
      
    }
  }

  void _onFormInitialized(
    TransactionFormInitialized event,
    Emitter<TransactionState> emit,
  ) {
    emit(TransactionFormState(
      selectedDate: DateTime.now(),
    ));
  }

  void _onFormTypeUpdated(
    TransactionFormTypeUpdated event,
    Emitter<TransactionState> emit,
  ) {
    final currentState = state;
    if (currentState is TransactionFormState) {
      emit(currentState.copyWith(
        selectedType: event.type,
        selectedBudgetId: null, 
        clearBudgetPreview: true,
      ));
    }
  }

  void _onFormBudgetUpdated(
    TransactionFormBudgetUpdated event,
    Emitter<TransactionState> emit,
  ) {
    final currentState = state;
    if (currentState is TransactionFormState) {
      emit(currentState.copyWith(
        selectedBudgetId: event.budgetId,
        clearBudgetPreview: true,
      ));
      
      
      if (currentState.selectedType == TransactionType.expense && 
          currentState.amount != null && 
          currentState.amount! > 0) {
        add(TransactionBudgetImpactPreviewRequested(
          budgetId: event.budgetId,
          amount: currentState.amount!,
        ));
      }
    }
  }

  void _onFormTitleUpdated(
    TransactionFormTitleUpdated event,
    Emitter<TransactionState> emit,
  ) {
    final currentState = state;
    if (currentState is TransactionFormState) {
      emit(currentState.copyWith(title: event.title));
    }
  }

  void _onFormDescriptionUpdated(
    TransactionFormDescriptionUpdated event,
    Emitter<TransactionState> emit,
  ) {
    final currentState = state;
    if (currentState is TransactionFormState) {
      emit(currentState.copyWith(description: event.description));
    }
  }

  void _onFormAmountUpdated(
    TransactionFormAmountUpdated event,
    Emitter<TransactionState> emit,
  ) {
    final currentState = state;
    if (currentState is TransactionFormState) {
      emit(currentState.copyWith(amount: event.amount));
      
      
      if (currentState.selectedType == TransactionType.expense && 
          currentState.selectedBudgetId != null && 
          event.amount > 0) {
        add(TransactionBudgetImpactPreviewRequested(
          budgetId: currentState.selectedBudgetId!,
          amount: event.amount,
        ));
      }
    }
  }

  void _onFormDateUpdated(
    TransactionFormDateUpdated event,
    Emitter<TransactionState> emit,
  ) {
    final currentState = state;
    if (currentState is TransactionFormState) {
      emit(currentState.copyWith(selectedDate: event.date));
    }
  }

  Future<void> _onFormSubmitted(
    TransactionFormSubmitted event,
    Emitter<TransactionState> emit,
  ) async {
    final currentState = state;
    if (currentState is! TransactionFormState || !currentState.isValid) {
      return;
    }

    emit(currentState.copyWith(isLoading: true));

    try {
      add(TransactionAddRequested(
        title: currentState.title,
        amount: currentState.amount!,
        budgetId: currentState.selectedBudgetId!,
        type: currentState.selectedType,
        date: currentState.selectedDate,
        description: currentState.description,
      ));
    } catch (e) {
      emit(currentState.copyWith(
        isLoading: false,
        errorMessage: 'Failed to save transaction: ${e.toString()}',
      ));
    }
  }

  void _onFormErrorCleared(
    TransactionFormErrorCleared event,
    Emitter<TransactionState> emit,
  ) {
    final currentState = state;
    if (currentState is TransactionFormState) {
      emit(currentState.copyWith(clearError: true));
    }
  }

  void _onFormReset(
    TransactionFormReset event,
    Emitter<TransactionState> emit,
  ) {
    add(const TransactionFormInitialized());
  }

  
  String _getErrorMessage(AppFailure failure) {
    switch (failure.runtimeType) {
      case ValidationFailure _:
        final validationFailure = failure as ValidationFailure;
        if (validationFailure.fieldErrors.isNotEmpty) {
          final firstError = validationFailure.fieldErrors.values.first.first;
          return firstError;
        }
        return validationFailure.message;
      
      case TransactionNotFoundFailure _:
        return 'Transaction not found. Please try again.';
      
      case CategoryNotFoundFailure _:
        return 'Category not found. Please select a valid category.';
      
      case NetworkFailure _:
        return 'Network error. Please check your connection and try again.';
      
      case DatabaseFailure _:
        return 'Database error. Please try again later.';
      
      case TransactionFailure _:
        return failure.message;
      
      default:
        return 'An unexpected error occurred. Please try again.';
    }
  }
}