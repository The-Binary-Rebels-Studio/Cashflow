import 'package:injectable/injectable.dart';
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

  Future<List<TransactionWithCategory>> getAllTransactions() async {
    return await transactionRepository.getAllTransactions();
  }

  Future<List<TransactionWithCategory>> getTransactionsByDateRange(DateTime startDate, DateTime endDate) async {
    return await transactionRepository.getTransactionsByDateRange(startDate, endDate);
  }

  Future<List<TransactionWithCategory>> getTransactionsByCategory(String categoryId) async {
    return await transactionRepository.getTransactionsByCategory(categoryId);
  }

  Future<List<TransactionWithCategory>> getTransactionsByType(TransactionType type) async {
    return await transactionRepository.getTransactionsByType(type);
  }

  Future<TransactionWithCategory?> getTransactionById(String id) async {
    return await transactionRepository.getTransactionById(id);
  }

  Future<void> addTransaction(TransactionEntity transaction) async {
    await transactionRepository.addTransaction(transaction);
  }

  Future<void> updateTransaction(TransactionEntity transaction) async {
    await transactionRepository.updateTransaction(transaction);
  }

  Future<void> deleteTransaction(String id) async {
    await transactionRepository.deleteTransaction(id);
  }

  Future<double> getTotalByCategory(String categoryId) async {
    return await transactionRepository.getTotalByCategory(categoryId);
  }

  Future<double> getTotalByType(TransactionType type) async {
    return await transactionRepository.getTotalByType(type);
  }

  Future<double> getTotalByCategoryAndDateRange(String categoryId, DateTime startDate, DateTime endDate) async {
    return await transactionRepository.getTotalByCategoryAndDateRange(categoryId, startDate, endDate);
  }

  Future<BudgetRemainingInfo?> calculateRemainingBudgetAfterExpense(
    String categoryId,
    double expenseAmount,
  ) async {
    final currentDate = DateTime.now();
    final startOfMonth = DateTime(currentDate.year, currentDate.month, 1);
    final endOfMonth = DateTime(currentDate.year, currentDate.month + 1, 0);

    final budgets = await budgetRepository.getBudgetsByCategory(categoryId);
    
    if (budgets.isEmpty) return null;

    final currentBudget = budgets.first;
    final category = await budgetRepository.getCategoryById(categoryId);
    
    if (category == null) return null;
    
    final currentSpending = await getTotalByCategoryAndDateRange(categoryId, startOfMonth, endOfMonth);
    final remainingBudget = currentBudget.amount - (currentSpending.abs() + expenseAmount);
    
    return BudgetRemainingInfo(
      budgetId: currentBudget.id,
      categoryName: category.name,
      budgetAmount: currentBudget.amount,
      currentSpending: currentSpending.abs(),
      expenseAmount: expenseAmount,
      remainingAmount: remainingBudget,
      isOverBudget: remainingBudget < 0,
    );
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