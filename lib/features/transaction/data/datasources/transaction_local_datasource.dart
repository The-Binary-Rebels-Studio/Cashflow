import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:injectable/injectable.dart';
import 'package:cashflow/features/transaction/data/models/transaction_model.dart';
import 'package:cashflow/features/transaction/domain/entities/transaction_entity.dart';

abstract class TransactionLocalDatasource {
  Future<List<TransactionModel>> getAllTransactions();
  Future<List<TransactionModel>> getTransactionsByDateRange(DateTime startDate, DateTime endDate);
  Future<List<TransactionModel>> getTransactionsByBudget(String budgetId);
  Future<List<TransactionModel>> getTransactionsByType(TransactionType type);
  Future<TransactionModel?> getTransactionById(String id);
  Future<void> insertTransaction(TransactionModel transaction);
  Future<void> updateTransaction(TransactionModel transaction);
  Future<void> deleteTransaction(String id);
  Future<double> getTotalByBudget(String budgetId);
  Future<double> getTotalByType(TransactionType type);
  Future<double> getTotalByBudgetAndDateRange(String budgetId, DateTime startDate, DateTime endDate);
}

@Injectable(as: TransactionLocalDatasource)
class TransactionLocalDatasourceImpl implements TransactionLocalDatasource {
  final Database _database;

  TransactionLocalDatasourceImpl(this._database);

  @override
  Future<List<TransactionModel>> getAllTransactions() async {
    final List<Map<String, dynamic>> maps = await _database.query(
      'transactions',
      orderBy: 'date DESC',
    );
    return maps.map((map) => TransactionModel.fromMap(map)).toList();
  }

  @override
  Future<List<TransactionModel>> getTransactionsByDateRange(DateTime startDate, DateTime endDate) async {
    final List<Map<String, dynamic>> maps = await _database.query(
      'transactions',
      where: 'date >= ? AND date <= ?',
      whereArgs: [startDate.toIso8601String(), endDate.toIso8601String()],
      orderBy: 'date DESC',
    );
    return maps.map((map) => TransactionModel.fromMap(map)).toList();
  }

  @override
  Future<List<TransactionModel>> getTransactionsByBudget(String budgetId) async {
    final List<Map<String, dynamic>> maps = await _database.query(
      'transactions',
      where: 'budget_id = ?',
      whereArgs: [budgetId],
      orderBy: 'date DESC',
    );
    return maps.map((map) => TransactionModel.fromMap(map)).toList();
  }

  @override
  Future<List<TransactionModel>> getTransactionsByType(TransactionType type) async {
    final List<Map<String, dynamic>> maps = await _database.query(
      'transactions',
      where: 'type = ?',
      whereArgs: [type.value],
      orderBy: 'date DESC',
    );
    return maps.map((map) => TransactionModel.fromMap(map)).toList();
  }

  @override
  Future<TransactionModel?> getTransactionById(String id) async {
    final List<Map<String, dynamic>> maps = await _database.query(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    
    if (maps.isEmpty) return null;
    return TransactionModel.fromMap(maps.first);
  }

  @override
  Future<void> insertTransaction(TransactionModel transaction) async {
    debugPrint('💾 [INSERT DEBUG] Inserting transaction:');
    debugPrint('   📝 Title: ${transaction.title}');
    debugPrint('   💰 Amount: ${transaction.amount}');
    debugPrint('   🏷️  Budget: ${transaction.budgetId}');
    debugPrint('   📅 Date: ${transaction.date}');
    debugPrint('   🏛️  Type: ${transaction.type}');
    debugPrint('---');
    
    await _database.insert(
      'transactions',
      transaction.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    
    debugPrint('✅ Transaction inserted successfully');
    debugPrint('---');
  }

  @override
  Future<void> updateTransaction(TransactionModel transaction) async {
    await _database.update(
      'transactions',
      transaction.toMap(),
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
  }

  @override
  Future<void> deleteTransaction(String id) async {
    await _database.delete(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<double> getTotalByBudget(String budgetId) async {
    final List<Map<String, dynamic>> result = await _database.rawQuery(
      'SELECT COALESCE(SUM(amount), 0) as total FROM transactions WHERE budget_id = ?',
      [budgetId],
    );
    return (result.first['total'] as num).toDouble();
  }

  @override
  Future<double> getTotalByType(TransactionType type) async {
    final List<Map<String, dynamic>> result = await _database.rawQuery(
      'SELECT COALESCE(SUM(amount), 0) as total FROM transactions WHERE type = ?',
      [type.value],
    );
    return (result.first['total'] as num).toDouble();
  }

  @override
  Future<double> getTotalByBudgetAndDateRange(String budgetId, DateTime startDate, DateTime endDate) async {
    // Use date-only comparison to avoid time precision issues
    final startDateString = DateTime(startDate.year, startDate.month, startDate.day).toIso8601String();
    final endDateString = DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59).toIso8601String();
    
    debugPrint('🔍 [QUERY DEBUG] getTotalByBudgetAndDateRange:');
    debugPrint('   🏷️  Budget: $budgetId');
    debugPrint('   📅 Period: $startDateString to $endDateString');
    
    // Debug: Show all transactions for this category first
    final allTransactions = await _database.rawQuery(
      'SELECT title, amount, date FROM transactions WHERE budget_id = ? ORDER BY date DESC',
      [budgetId],
    );
    debugPrint('   📊 All transactions for budget $budgetId:');
    for (final tx in allTransactions.take(5)) { // Show max 5 recent transactions
      debugPrint('     - ${tx['title']}: ${tx['amount']} on ${tx['date']}');
    }
    
    final List<Map<String, dynamic>> result = await _database.rawQuery(
      'SELECT COALESCE(SUM(amount), 0) as total FROM transactions WHERE budget_id = ? AND date >= ? AND date <= ?',
      [budgetId, startDateString, endDateString],
    );
    
    final total = (result.first['total'] as num).toDouble();
    debugPrint('   💰 Total found: $total');
    debugPrint('---');
    
    return total;
  }
}