import 'package:sqflite/sqflite.dart';
import 'package:injectable/injectable.dart';
import 'package:cashflow/features/transaction/data/models/transaction_model.dart';
import 'package:cashflow/features/transaction/domain/entities/transaction_entity.dart';

abstract class TransactionLocalDatasource {
  Future<List<TransactionModel>> getAllTransactions();
  Future<List<TransactionModel>> getTransactionsByDateRange(DateTime startDate, DateTime endDate);
  Future<List<TransactionModel>> getTransactionsByCategory(String categoryId);
  Future<List<TransactionModel>> getTransactionsByType(TransactionType type);
  Future<TransactionModel?> getTransactionById(String id);
  Future<void> insertTransaction(TransactionModel transaction);
  Future<void> updateTransaction(TransactionModel transaction);
  Future<void> deleteTransaction(String id);
  Future<double> getTotalByCategory(String categoryId);
  Future<double> getTotalByType(TransactionType type);
  Future<double> getTotalByCategoryAndDateRange(String categoryId, DateTime startDate, DateTime endDate);
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
  Future<List<TransactionModel>> getTransactionsByCategory(String categoryId) async {
    final List<Map<String, dynamic>> maps = await _database.query(
      'transactions',
      where: 'category_id = ?',
      whereArgs: [categoryId],
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
    await _database.insert(
      'transactions',
      transaction.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
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
  Future<double> getTotalByCategory(String categoryId) async {
    final List<Map<String, dynamic>> result = await _database.rawQuery(
      'SELECT COALESCE(SUM(amount), 0) as total FROM transactions WHERE category_id = ?',
      [categoryId],
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
  Future<double> getTotalByCategoryAndDateRange(String categoryId, DateTime startDate, DateTime endDate) async {
    final List<Map<String, dynamic>> result = await _database.rawQuery(
      'SELECT COALESCE(SUM(amount), 0) as total FROM transactions WHERE category_id = ? AND date >= ? AND date <= ?',
      [categoryId, startDate.toIso8601String(), endDate.toIso8601String()],
    );
    return (result.first['total'] as num).toDouble();
  }
}