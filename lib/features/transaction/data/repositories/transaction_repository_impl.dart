import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:cashflow/features/transaction/domain/entities/transaction_entity.dart';
import 'package:cashflow/features/transaction/domain/entities/transaction_with_budget.dart';
import 'package:cashflow/features/transaction/domain/repositories/transaction_repository.dart';
import 'package:cashflow/features/transaction/data/datasources/transaction_local_datasource.dart';
import 'package:cashflow/features/transaction/data/models/transaction_model.dart';
import 'package:cashflow/features/budget_management/domain/repositories/budget_management_repository.dart';
import 'package:cashflow/features/budget_management/domain/entities/budget_entity.dart';

@Injectable(as: TransactionRepository)
class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionLocalDatasource localDatasource;
  final BudgetManagementRepository budgetManagementRepository;

  TransactionRepositoryImpl({
    required this.localDatasource,
    required this.budgetManagementRepository,
  });

  @override
  Future<List<TransactionWithBudget>> getAllTransactions() async {
    final transactions = await localDatasource.getAllTransactions();
    return await _combineWithBudgets(transactions);
  }

  @override
  Future<List<TransactionWithBudget>> getTransactionsByDateRange(DateTime startDate, DateTime endDate) async {
    final transactions = await localDatasource.getTransactionsByDateRange(startDate, endDate);
    return await _combineWithBudgets(transactions);
  }

  @override
  Future<List<TransactionWithBudget>> getTransactionsByBudget(String budgetId) async {
    final transactions = await localDatasource.getTransactionsByBudget(budgetId);
    return await _combineWithBudgets(transactions);
  }

  @override
  Future<List<TransactionWithBudget>> getTransactionsByType(TransactionType type) async {
    final transactions = await localDatasource.getTransactionsByType(type);
    return await _combineWithBudgets(transactions);
  }

  @override
  Future<TransactionWithBudget?> getTransactionById(String id) async {
    final transaction = await localDatasource.getTransactionById(id);
    if (transaction == null) return null;
    
    
    final budget = await budgetManagementRepository.getBudgetById(transaction.budgetId);
    if (budget != null) {
      return TransactionWithBudget(
        transaction: transaction,
        budget: budget,
      );
    } else {
      
      // Check if this is an income transaction with generated ID
      if (transaction.budgetId.startsWith('income_') && transaction.type == TransactionType.income) {
        
        // Create a virtual budget for income transaction
        final now = DateTime.now();
        final virtualBudget = BudgetEntity(
          id: transaction.budgetId,
          name: transaction.title, // Use transaction title as budget name
          description: 'Income transaction - no budget plan required',
          amount: 0, // Income doesn't have budget limits
          categoryId: 'virtual_income_category',
          period: BudgetPeriod.monthly,
          startDate: now,
          endDate: now.add(const Duration(days: 30)),
          createdAt: now,
          updatedAt: now,
          isActive: true,
        );
        
        return TransactionWithBudget(
          transaction: transaction,
          budget: virtualBudget,
        );
      } else {
        // For debugging: Check if this is a legacy transaction with categoryId
        final category = await budgetManagementRepository.getCategoryById(transaction.budgetId);
        if (category != null) {
          
          // Create a temporary budget for this legacy transaction
          final now = DateTime.now();
          final tempBudget = BudgetEntity(
            id: transaction.budgetId,
            name: '${category.name} (Legacy)',
            description: 'Legacy transaction - please create proper budget plan',
            amount: 0,
            categoryId: transaction.budgetId,
            period: BudgetPeriod.monthly,
            startDate: now,
            endDate: now.add(const Duration(days: 30)),
            createdAt: now,
            updatedAt: now,
            isActive: true,
          );
          
          return TransactionWithBudget(
            transaction: transaction,
            budget: tempBudget,
          );
        }
      }
    }
    
    return null;
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
  Future<double> getTotalByBudget(String budgetId) async {
    return await localDatasource.getTotalByBudget(budgetId);
  }

  @override
  Future<double> getTotalByType(TransactionType type) async {
    return await localDatasource.getTotalByType(type);
  }

  @override
  Future<double> getTotalByBudgetAndDateRange(String budgetId, DateTime startDate, DateTime endDate) async {
    return await localDatasource.getTotalByBudgetAndDateRange(budgetId, startDate, endDate);
  }

  Future<List<TransactionWithBudget>> _combineWithBudgets(List<TransactionModel> transactions) async {
    final List<TransactionWithBudget> result = [];
    
    
    for (final transaction in transactions) {
      
      final budget = await budgetManagementRepository.getBudgetById(transaction.budgetId);
      if (budget != null) {
        result.add(TransactionWithBudget(
          transaction: transaction,
          budget: budget,
        ));
      } else {
        
        // Check if this is an income transaction with generated ID
        if (transaction.budgetId.startsWith('income_') && transaction.type == TransactionType.income) {
          
          // Create a virtual budget for income transaction
          final now = DateTime.now();
          final virtualBudget = BudgetEntity(
            id: transaction.budgetId,
            name: transaction.title, // Use transaction title as budget name
            description: 'Income transaction - no budget plan required',
            amount: 0, // Income doesn't have budget limits
            categoryId: 'virtual_income_category',
            period: BudgetPeriod.monthly,
            startDate: now,
            endDate: now.add(const Duration(days: 30)),
            createdAt: now,
            updatedAt: now,
            isActive: true,
          );
          
          result.add(TransactionWithBudget(
            transaction: transaction,
            budget: virtualBudget,
          ));
        } else {
          // For debugging: Check if this is a legacy transaction with categoryId
          final category = await budgetManagementRepository.getCategoryById(transaction.budgetId);
          if (category != null) {
            
            // Create a temporary budget for this legacy transaction
            final now = DateTime.now();
            final tempBudget = BudgetEntity(
              id: transaction.budgetId,
              name: '${category.name} (Legacy)',
              description: 'Legacy transaction - please create proper budget plan',
              amount: 0,
              categoryId: transaction.budgetId,
              period: BudgetPeriod.monthly,
              startDate: now,
              endDate: now.add(const Duration(days: 30)),
              createdAt: now,
              updatedAt: now,
              isActive: true,
            );
            
            result.add(TransactionWithBudget(
              transaction: transaction,
              budget: tempBudget,
            ));
          }
        }
      }
    }
    
    return result;
  }

}