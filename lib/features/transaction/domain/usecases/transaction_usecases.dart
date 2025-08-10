import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:cashflow/core/error/result.dart';
import 'package:cashflow/core/error/failures.dart';
import 'package:cashflow/features/transaction/domain/entities/transaction_entity.dart';
import 'package:cashflow/features/transaction/domain/entities/transaction_with_category.dart';
import 'package:cashflow/features/transaction/domain/repositories/transaction_repository.dart';
import 'package:cashflow/features/budget_management/domain/repositories/budget_management_repository.dart';

@injectable
class TransactionUsecases {
  final TransactionRepository transactionRepository;
  final BudgetManagementRepository budgetRepository;

  TransactionUsecases({
    required this.transactionRepository,
    required this.budgetRepository,
  });

  Future<Result<List<TransactionWithCategory>>> getAllTransactions() async {
    try {
      final transactions = await transactionRepository.getAllTransactions();
      return success(transactions);
    } catch (e, stackTrace) {
      return failure(TransactionFailure(
        message: 'Failed to get all transactions: ${e.toString()}',
        originalError: e,
        stackTrace: stackTrace,
      ));
    }
  }

  Future<Result<List<TransactionWithCategory>>> getTransactionsByDateRange(DateTime startDate, DateTime endDate) async {
    try {
      if (startDate.isAfter(endDate)) {
        return failure(ValidationFailure(
          message: 'Start date must be before end date',
          fieldErrors: {
            'startDate': ['Start date must be before end date'],
            'endDate': ['End date must be after start date'],
          },
        ));
      }
      
      final transactions = await transactionRepository.getTransactionsByDateRange(startDate, endDate);
      return success(transactions);
    } catch (e, stackTrace) {
      return failure(TransactionFailure(
        message: 'Failed to get transactions by date range: ${e.toString()}',
        originalError: e,
        stackTrace: stackTrace,
      ));
    }
  }

  Future<Result<List<TransactionWithCategory>>> getTransactionsByCategory(String categoryId) async {
    try {
      if (categoryId.trim().isEmpty) {
        return failure(ValidationFailure(
          message: 'Category ID cannot be empty',
          fieldErrors: {'categoryId': ['Category ID is required']},
        ));
      }
      
      final transactions = await transactionRepository.getTransactionsByCategory(categoryId);
      return success(transactions);
    } catch (e, stackTrace) {
      return failure(TransactionFailure(
        message: 'Failed to get transactions by category: ${e.toString()}',
        originalError: e,
        stackTrace: stackTrace,
      ));
    }
  }

  Future<Result<List<TransactionWithCategory>>> getTransactionsByType(TransactionType type) async {
    try {
      final transactions = await transactionRepository.getTransactionsByType(type);
      return success(transactions);
    } catch (e, stackTrace) {
      return failure(TransactionFailure(
        message: 'Failed to get transactions by type: ${e.toString()}',
        originalError: e,
        stackTrace: stackTrace,
      ));
    }
  }

  Future<Result<TransactionWithCategory>> getTransactionById(String id) async {
    try {
      if (id.trim().isEmpty) {
        return failure(ValidationFailure(
          message: 'Transaction ID cannot be empty',
          fieldErrors: {'id': ['Transaction ID is required']},
        ));
      }
      
      final transaction = await transactionRepository.getTransactionById(id);
      if (transaction == null) {
        return failure(TransactionNotFoundFailure(id));
      }
      
      return success(transaction);
    } catch (e, stackTrace) {
      return failure(TransactionFailure(
        message: 'Failed to get transaction by ID: ${e.toString()}',
        originalError: e,
        stackTrace: stackTrace,
      ));
    }
  }

  Future<Result<void>> addTransaction(TransactionEntity transaction) async {
    try {
      // Validation
      final validationResult = _validateTransaction(transaction);
      if (validationResult.isFailure) {
        return failure(validationResult.failure!);
      }
      
      await transactionRepository.addTransaction(transaction);
      return success(null);
    } catch (e, stackTrace) {
      return failure(TransactionFailure(
        message: 'Failed to add transaction: ${e.toString()}',
        originalError: e,
        stackTrace: stackTrace,
      ));
    }
  }

  Future<Result<void>> updateTransaction(TransactionEntity transaction) async {
    try {
      // Validation
      final validationResult = _validateTransaction(transaction);
      if (validationResult.isFailure) {
        return failure(validationResult.failure!);
      }
      
      await transactionRepository.updateTransaction(transaction);
      return success(null);
    } catch (e, stackTrace) {
      return failure(TransactionFailure(
        message: 'Failed to update transaction: ${e.toString()}',
        originalError: e,
        stackTrace: stackTrace,
      ));
    }
  }

  Future<Result<void>> deleteTransaction(String id) async {
    try {
      if (id.trim().isEmpty) {
        return failure(ValidationFailure(
          message: 'Transaction ID cannot be empty',
          fieldErrors: {'id': ['Transaction ID is required']},
        ));
      }
      
      await transactionRepository.deleteTransaction(id);
      return success(null);
    } catch (e, stackTrace) {
      return failure(TransactionFailure(
        message: 'Failed to delete transaction: ${e.toString()}',
        originalError: e,
        stackTrace: stackTrace,
      ));
    }
  }

  Future<Result<double>> getTotalByCategory(String categoryId) async {
    try {
      if (categoryId.trim().isEmpty) {
        return failure(ValidationFailure(
          message: 'Category ID cannot be empty',
          fieldErrors: {'categoryId': ['Category ID is required']},
        ));
      }
      
      final total = await transactionRepository.getTotalByCategory(categoryId);
      return success(total);
    } catch (e, stackTrace) {
      return failure(TransactionFailure(
        message: 'Failed to get total by category: ${e.toString()}',
        originalError: e,
        stackTrace: stackTrace,
      ));
    }
  }

  Future<Result<double>> getTotalByType(TransactionType type) async {
    try {
      final total = await transactionRepository.getTotalByType(type);
      return success(total);
    } catch (e, stackTrace) {
      return failure(TransactionFailure(
        message: 'Failed to get total by type: ${e.toString()}',
        originalError: e,
        stackTrace: stackTrace,
      ));
    }
  }

  Future<Result<double>> getTotalByCategoryAndDateRange(String categoryId, DateTime startDate, DateTime endDate) async {
    try {
      if (categoryId.trim().isEmpty) {
        return failure(ValidationFailure(
          message: 'Category ID cannot be empty',
          fieldErrors: {'categoryId': ['Category ID is required']},
        ));
      }
      
      if (startDate.isAfter(endDate)) {
        return failure(ValidationFailure(
          message: 'Start date must be before end date',
          fieldErrors: {
            'startDate': ['Start date must be before end date'],
            'endDate': ['End date must be after start date'],
          },
        ));
      }
      
      final total = await transactionRepository.getTotalByCategoryAndDateRange(categoryId, startDate, endDate);
      return success(total);
    } catch (e, stackTrace) {
      return failure(TransactionFailure(
        message: 'Failed to get total by category and date range: ${e.toString()}',
        originalError: e,
        stackTrace: stackTrace,
      ));
    }
  }

  /// Validates transaction entity
  Result<void> _validateTransaction(TransactionEntity transaction) {
    debugPrint('🔍 [VALIDATION DEBUG] Validating transaction:');
    debugPrint('   📝 Title: ${transaction.title}');
    debugPrint('   💰 Amount: ${transaction.amount} (${transaction.type})');
    debugPrint('   🏷️  Category: ${transaction.categoryId}');
    debugPrint('   📝 Description: ${transaction.description ?? 'null'}');
    
    final Map<String, List<String>> fieldErrors = {};
    
    // Description is optional - only validate if provided
    if (transaction.description != null && transaction.description!.trim().isEmpty) {
      fieldErrors['description'] = ['Transaction description cannot be empty if provided'];
    }
    
    // Amount validation: income must be positive, expense must be negative, and not zero
    if (transaction.amount == 0) {
      fieldErrors['amount'] = ['Transaction amount cannot be zero'];
    } else if (transaction.type == TransactionType.income && transaction.amount <= 0) {
      fieldErrors['amount'] = ['Income amount must be positive'];
    } else if (transaction.type == TransactionType.expense && transaction.amount >= 0) {
      fieldErrors['amount'] = ['Expense amount must be negative'];
    }
    
    if (transaction.categoryId.trim().isEmpty) {
      fieldErrors['categoryId'] = ['Category selection is required'];
    }
    
    if (fieldErrors.isNotEmpty) {
      debugPrint('❌ [VALIDATION FAILED] Errors found:');
      fieldErrors.forEach((field, errors) {
        debugPrint('   $field: ${errors.join(', ')}');
      });
      debugPrint('---');
      
      return failure(ValidationFailure(
        message: 'Transaction validation failed',
        fieldErrors: fieldErrors,
      ));
    }
    
    debugPrint('✅ [VALIDATION SUCCESS] Transaction is valid');
    debugPrint('---');
    
    return success(null);
  }

  Future<Result<BudgetRemainingInfo>> calculateRemainingBudgetAfterExpense(
    String categoryId,
    double expenseAmount,
  ) async {
    try {
      final currentDate = DateTime.now();
      final startOfMonth = DateTime(currentDate.year, currentDate.month, 1);
      final endOfMonth = DateTime(currentDate.year, currentDate.month + 1, 0);

      final budgets = await budgetRepository.getBudgetsByCategory(categoryId);
      
      if (budgets.isEmpty) {
        return failure(BudgetNotFoundFailure(categoryId));
      }

      final currentBudget = budgets.first;
      final category = await budgetRepository.getCategoryById(categoryId);
      
      if (category == null) {
        return failure(CategoryNotFoundFailure(categoryId));
      }
      
      final totalResult = await getTotalByCategoryAndDateRange(categoryId, startOfMonth, endOfMonth);
      
      if (totalResult.isFailure) {
        return failure(totalResult.failure!);
      }
      
      final currentSpending = totalResult.value!;
      final remainingBudget = currentBudget.amount - (currentSpending.abs() + expenseAmount);
      
      final budgetInfo = BudgetRemainingInfo(
        budgetId: currentBudget.id,
        categoryName: category.name,
        budgetAmount: currentBudget.amount,
        currentSpending: currentSpending.abs(),
        expenseAmount: expenseAmount,
        remainingAmount: remainingBudget,
        isOverBudget: remainingBudget < 0,
      );
      
      return success(budgetInfo);
    } catch (e, stackTrace) {
      return failure(BudgetFailure(
        message: 'Failed to calculate remaining budget: ${e.toString()}',
        originalError: e,
        stackTrace: stackTrace,
      ));
    }
  }
}

class BudgetRemainingInfo {
  final String budgetId;
  final String categoryName;
  final double budgetAmount;
  final double currentSpending;
  final double expenseAmount;
  final double remainingAmount;
  final bool isOverBudget;

  BudgetRemainingInfo({
    required this.budgetId,
    required this.categoryName,
    required this.budgetAmount,
    required this.currentSpending,
    required this.expenseAmount,
    required this.remainingAmount,
    required this.isOverBudget,
  });

  double get totalSpendingAfterTransaction => currentSpending + expenseAmount;
  double get percentageUsed => (totalSpendingAfterTransaction / budgetAmount) * 100;
}