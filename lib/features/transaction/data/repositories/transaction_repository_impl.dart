import 'package:injectable/injectable.dart';
import 'package:cashflow/features/transaction/domain/entities/transaction_entity.dart';
import 'package:cashflow/features/transaction/domain/entities/transaction_with_category.dart';
import 'package:cashflow/features/transaction/domain/repositories/transaction_repository.dart';
import 'package:cashflow/features/transaction/data/datasources/transaction_local_datasource.dart';
import 'package:cashflow/features/transaction/data/models/transaction_model.dart';
import 'package:cashflow/features/budget_management/domain/repositories/budget_management_repository.dart';

@Injectable(as: TransactionRepository)
class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionLocalDatasource localDatasource;
  final BudgetManagementRepository budgetManagementRepository;

  TransactionRepositoryImpl({
    required this.localDatasource,
    required this.budgetManagementRepository,
  });

  @override
  Future<List<TransactionWithCategory>> getAllTransactions() async {
    final transactions = await localDatasource.getAllTransactions();
    return await _combineWithCategories(transactions);
  }

  @override
  Future<List<TransactionWithCategory>> getTransactionsByDateRange(DateTime startDate, DateTime endDate) async {
    final transactions = await localDatasource.getTransactionsByDateRange(startDate, endDate);
    return await _combineWithCategories(transactions);
  }

  @override
  Future<List<TransactionWithCategory>> getTransactionsByCategory(String categoryId) async {
    final transactions = await localDatasource.getTransactionsByCategory(categoryId);
    return await _combineWithCategories(transactions);
  }

  @override
  Future<List<TransactionWithCategory>> getTransactionsByType(TransactionType type) async {
    final transactions = await localDatasource.getTransactionsByType(type);
    return await _combineWithCategories(transactions);
  }

  @override
  Future<TransactionWithCategory?> getTransactionById(String id) async {
    final transaction = await localDatasource.getTransactionById(id);
    if (transaction == null) return null;
    
    final category = await budgetManagementRepository.getCategoryById(transaction.categoryId);
    if (category == null) return null;
    
    return TransactionWithCategory(
      transaction: transaction,
      category: category,
    );
  }

  @override
  Future<void> addTransaction(TransactionEntity transaction) async {
    final model = TransactionModel.fromEntity(transaction);
    await localDatasource.insertTransaction(model);
  }

  @override
  Future<void> updateTransaction(TransactionEntity transaction) async {
    final model = TransactionModel.fromEntity(transaction);
    await localDatasource.updateTransaction(model);
  }

  @override
  Future<void> deleteTransaction(String id) async {
    await localDatasource.deleteTransaction(id);
  }

  @override
  Future<double> getTotalByCategory(String categoryId) async {
    return await localDatasource.getTotalByCategory(categoryId);
  }

  @override
  Future<double> getTotalByType(TransactionType type) async {
    return await localDatasource.getTotalByType(type);
  }

  @override
  Future<double> getTotalByCategoryAndDateRange(String categoryId, DateTime startDate, DateTime endDate) async {
    return await localDatasource.getTotalByCategoryAndDateRange(categoryId, startDate, endDate);
  }

  Future<List<TransactionWithCategory>> _combineWithCategories(List<TransactionModel> transactions) async {
    final List<TransactionWithCategory> result = [];
    
    for (final transaction in transactions) {
      final category = await budgetManagementRepository.getCategoryById(transaction.categoryId);
      if (category != null) {
        result.add(TransactionWithCategory(
          transaction: transaction,
          category: category,
        ));
      }
    }
    
    return result;
  }
}