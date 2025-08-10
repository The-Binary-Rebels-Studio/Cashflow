import 'package:cashflow/features/transaction/domain/entities/transaction_entity.dart';
import 'package:cashflow/features/transaction/domain/entities/transaction_with_category.dart';

abstract class TransactionRepository {
  Future<List<TransactionWithCategory>> getAllTransactions();
  Future<List<TransactionWithCategory>> getTransactionsByDateRange(DateTime startDate, DateTime endDate);
  Future<List<TransactionWithCategory>> getTransactionsByCategory(String categoryId);
  Future<List<TransactionWithCategory>> getTransactionsByType(TransactionType type);
  Future<TransactionWithCategory?> getTransactionById(String id);
  Future<void> addTransaction(TransactionEntity transaction);
  Future<void> updateTransaction(TransactionEntity transaction);
  Future<void> deleteTransaction(String id);
  Future<double> getTotalByCategory(String categoryId);
  Future<double> getTotalByType(TransactionType type);
  Future<double> getTotalByCategoryAndDateRange(String categoryId, DateTime startDate, DateTime endDate);
}