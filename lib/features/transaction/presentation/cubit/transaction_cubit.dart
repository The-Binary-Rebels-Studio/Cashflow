import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:cashflow/core/error/failures.dart';
import 'package:cashflow/features/transaction/domain/entities/transaction_entity.dart';
import 'package:cashflow/features/transaction/domain/entities/transaction_with_category.dart';
import 'package:cashflow/features/transaction/domain/usecases/transaction_usecases.dart';
import 'package:cashflow/features/budget_management/domain/entities/category_entity.dart';
import 'package:cashflow/features/budget_management/domain/repositories/budget_management_repository.dart';
import 'package:cashflow/features/transaction/presentation/cubit/transaction_state.dart';

@injectable
class TransactionCubit extends Cubit<TransactionState> {
  final TransactionUsecases transactionUsecases;
  final BudgetManagementRepository budgetManagementRepository;

  TransactionCubit(
    this.transactionUsecases,
    this.budgetManagementRepository,
  ) : super(TransactionInitial());

  Future<void> loadTransactions() async {
    emit(TransactionLoading());
    
    // Execute all use cases and collect results
    final results = await Future.wait([
      transactionUsecases.getAllTransactions(),
      transactionUsecases.getTransactionsByType(TransactionType.income),
      transactionUsecases.getTransactionsByType(TransactionType.expense),
      transactionUsecases.getTotalByType(TransactionType.income),
      transactionUsecases.getTotalByType(TransactionType.expense),
    ]);
    
    // Check if any operation failed
    for (final result in results) {
      if (result.isFailure) {
        emit(TransactionError(_getErrorMessage(result.failure!)));
        return;
      }
    }
    
    try {
      // All operations succeeded, extract values
      final transactions = results[0].value as List<TransactionWithCategory>;
      final incomeTransactions = results[1].value as List<TransactionWithCategory>;
      final expenseTransactions = results[2].value as List<TransactionWithCategory>;
      final totalIncome = results[3].value as double;
      final totalExpense = results[4].value as double;
      final balance = totalIncome + totalExpense; // expense amounts are negative
      
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

  Future<void> addTransaction({
    required String title,
    required double amount,
    required String categoryId,
    required TransactionType type,
    required DateTime date,
    String? description,
  }) async {
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
        title: title,
        description: description,
        amount: type == TransactionType.income ? amount : -amount,
        categoryId: categoryId,
        type: type,
        date: date,
        createdAt: now,
        updatedAt: now,
      );

      BudgetRemainingInfo? budgetInfo;
      if (type == TransactionType.expense) {
        final budgetResult = await transactionUsecases.calculateRemainingBudgetAfterExpense(
          categoryId,
          amount,
        );
        
        budgetResult.fold(
          onSuccess: (info) => budgetInfo = info,
          onFailure: (_) => budgetInfo = null, // Ignore budget calculation errors
        );
      }

      final addResult = await transactionUsecases.addTransaction(transaction);
      
      if (addResult.isFailure) {
        emit(TransactionError(_getErrorMessage(addResult.failure!)));
        return;
      }
      
      emit(TransactionOperationSuccess(
        type == TransactionType.income 
          ? 'Income added successfully!' 
          : 'Expense added successfully!',
        budgetInfo: budgetInfo,
      ));

      await loadTransactions();
    } catch (e) {
      emit(TransactionError('Failed to add transaction: ${e.toString()}'));
    }
  }

  Future<void> updateTransaction(TransactionEntity transaction) async {
    try {
      await transactionUsecases.updateTransaction(transaction);
      emit(const TransactionOperationSuccess('Transaction updated successfully!'));
      await loadTransactions();
    } catch (e) {
      emit(TransactionError('Failed to update transaction: ${e.toString()}'));
    }
  }

  Future<void> deleteTransaction(String id) async {
    try {
      await transactionUsecases.deleteTransaction(id);
      emit(const TransactionOperationSuccess('Transaction deleted successfully!'));
      await loadTransactions();
    } catch (e) {
      emit(TransactionError('Failed to delete transaction: ${e.toString()}'));
    }
  }

  Future<void> previewBudgetImpact(String categoryId, double amount) async {
    if (amount <= 0) return;
    
    try {
      final budgetResult = await transactionUsecases.calculateRemainingBudgetAfterExpense(
        categoryId,
        amount,
      );
      
      final currentState = state;
      if (currentState is TransactionFormState) {
        budgetResult.fold(
          onSuccess: (budgetInfo) {
            emit(currentState.copyWith(budgetPreview: budgetInfo));
          },
          onFailure: (_) {
            // Silently handle budget preview errors
            emit(currentState.copyWith(budgetPreview: null));
          },
        );
      }
    } catch (e) {
      // Silently handle budget preview errors
    }
  }

  void initializeForm() {
    emit(TransactionFormState(
      selectedDate: DateTime.now(),
    ));
  }

  void updateFormType(TransactionType type) {
    final currentState = state;
    if (currentState is TransactionFormState) {
      emit(currentState.copyWith(
        selectedType: type,
        selectedCategoryId: null, // Reset category when type changes
        clearBudgetPreview: true,
      ));
    }
  }

  void updateFormCategory(String categoryId) {
    final currentState = state;
    if (currentState is TransactionFormState) {
      emit(currentState.copyWith(
        selectedCategoryId: categoryId,
        clearBudgetPreview: true,
      ));
      
      // Preview budget impact for expenses
      if (currentState.selectedType == TransactionType.expense && 
          currentState.amount != null && 
          currentState.amount! > 0) {
        previewBudgetImpact(categoryId, currentState.amount!);
      }
    }
  }

  void updateFormTitle(String title) {
    final currentState = state;
    if (currentState is TransactionFormState) {
      emit(currentState.copyWith(title: title));
    }
  }

  void updateFormDescription(String description) {
    final currentState = state;
    if (currentState is TransactionFormState) {
      emit(currentState.copyWith(description: description));
    }
  }

  void updateFormAmount(double amount) {
    final currentState = state;
    if (currentState is TransactionFormState) {
      emit(currentState.copyWith(amount: amount));
      
      // Preview budget impact for expenses
      if (currentState.selectedType == TransactionType.expense && 
          currentState.selectedCategoryId != null && 
          amount > 0) {
        previewBudgetImpact(currentState.selectedCategoryId!, amount);
      }
    }
  }

  void updateFormDate(DateTime date) {
    final currentState = state;
    if (currentState is TransactionFormState) {
      emit(currentState.copyWith(selectedDate: date));
    }
  }

  Future<void> submitForm() async {
    final currentState = state;
    if (currentState is! TransactionFormState || !currentState.isValid) {
      return;
    }

    emit(currentState.copyWith(isLoading: true));

    try {
      await addTransaction(
        title: currentState.title,
        amount: currentState.amount!,
        categoryId: currentState.selectedCategoryId!,
        type: currentState.selectedType,
        date: currentState.selectedDate,
        description: currentState.description,
      );
    } catch (e) {
      emit(currentState.copyWith(
        isLoading: false,
        errorMessage: 'Failed to save transaction: ${e.toString()}',
      ));
    }
  }

  void clearFormError() {
    final currentState = state;
    if (currentState is TransactionFormState) {
      emit(currentState.copyWith(clearError: true));
    }
  }

  void resetForm() {
    initializeForm();
  }

  /// Convert AppFailure to user-friendly error message
  String _getErrorMessage(AppFailure failure) {
    switch (failure.runtimeType) {
      case ValidationFailure:
        final validationFailure = failure as ValidationFailure;
        if (validationFailure.fieldErrors.isNotEmpty) {
          final firstError = validationFailure.fieldErrors.values.first.first;
          return firstError;
        }
        return validationFailure.message;
      
      case TransactionNotFoundFailure:
        return 'Transaction not found. Please try again.';
      
      case CategoryNotFoundFailure:
        return 'Category not found. Please select a valid category.';
      
      case NetworkFailure:
        return 'Network error. Please check your connection and try again.';
      
      case DatabaseFailure:
        return 'Database error. Please try again later.';
      
      case TransactionFailure:
        return failure.message;
      
      default:
        return 'An unexpected error occurred. Please try again.';
    }
  }
}