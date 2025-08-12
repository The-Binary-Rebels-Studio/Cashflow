import 'package:cashflow/features/transaction/domain/entities/transaction_entity.dart';
import 'package:cashflow/features/transaction/domain/entities/transaction_with_budget.dart';

abstract class TransactionRepository {
  Future<List<TransactionWithBudget>> getAllTransactions();
  Future<List<TransactionWithBudget>> getTransactionsByDateRange(DateTime startDate, DateTime endDate);
  Future<List<TransactionWithBudget>> getTransactionsByBudget(String budgetId);
  Future<List<TransactionWithBudget>> getTransactionsByType(TransactionType type);
  Future<TransactionWithBudget?> getTransactionById(String id);
  Future<void> addTransaction(TransactionEntity transaction);
  Future<void> updateTransaction(TransactionEntity transaction);
  Future<void> deleteTransaction(String id);
  Future<double> getTotalByBudget(String budgetId);
  Future<double> getTotalByType(TransactionType type);
  Future<double> getTotalByBudgetAndDateRange(String budgetId, DateTime startDate, DateTime endDate);
}