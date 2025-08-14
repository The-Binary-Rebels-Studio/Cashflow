import 'package:sqflite/sqflite.dart';
import 'package:injectable/injectable.dart';
import 'package:cashflow/features/budget_management/data/models/budget_model.dart';
import 'package:cashflow/features/budget_management/domain/entities/budget_entity.dart';

abstract class BudgetLocalDataSource {
  Future<List<BudgetModel>> getAllBudgets();
  Future<List<BudgetModel>> getActiveBudgets();
  Future<List<BudgetModel>> getBudgetsByPeriod(BudgetPeriod period);
  Future<BudgetModel?> getBudgetById(String id);
  Future<List<BudgetModel>> getBudgetsByCategory(String categoryId);
  Future<String> insertBudget(BudgetModel budget);
  Future<void> updateBudget(BudgetModel budget);
  Future<void> deleteBudget(String id);
  Future<int> getBudgetsCount();
  Future<List<BudgetModel>> searchBudgets(String query);
  Future<List<BudgetModel>> getCurrentPeriodBudgets();
}

@Injectable(as: BudgetLocalDataSource)
class BudgetLocalDataSourceImpl implements BudgetLocalDataSource {
  final Database _database;

  BudgetLocalDataSourceImpl(this._database);

  static const String _tableName = 'budgets';

  @override
  Future<List<BudgetModel>> getAllBudgets() async {
    final List<Map<String, dynamic>> maps = await _database.query(
      _tableName,
      where: 'is_active = ?',
      whereArgs: [1],
      orderBy: 'created_at DESC',
    );

    return List.generate(maps.length, (i) => BudgetModel.fromMap(maps[i]));
  }

  @override
  Future<List<BudgetModel>> getActiveBudgets() async {
    // For recurring budgets, we only need to check isActive flag
    // Budget periods are calculated dynamically based on current date
    final List<Map<String, dynamic>> maps = await _database.query(
      _tableName,
      where: 'is_active = ?',
      whereArgs: [1],
      orderBy: 'created_at DESC',
    );

    // Debug: Print active budgets found
 

    return List.generate(maps.length, (i) => BudgetModel.fromMap(maps[i]));
  }

  @override
  Future<List<BudgetModel>> getBudgetsByPeriod(BudgetPeriod period) async {
    final List<Map<String, dynamic>> maps = await _database.query(
      _tableName,
      where: 'period = ? AND is_active = ?',
      whereArgs: [period.value, 1],
      orderBy: 'created_at DESC',
    );

    return List.generate(maps.length, (i) => BudgetModel.fromMap(maps[i]));
  }

  @override
  Future<BudgetModel?> getBudgetById(String id) async {
    final List<Map<String, dynamic>> maps = await _database.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (maps.isEmpty) return null;
    return BudgetModel.fromMap(maps.first);
  }

  @override
  Future<List<BudgetModel>> getBudgetsByCategory(String categoryId) async {
    final List<Map<String, dynamic>> maps = await _database.query(
      _tableName,
      where: 'category_id = ? AND is_active = ?',
      whereArgs: [categoryId, 1],
      orderBy: 'created_at DESC',
    );

    return List.generate(maps.length, (i) => BudgetModel.fromMap(maps[i]));
  }

  @override
  Future<String> insertBudget(BudgetModel budget) async {
    await _database.insert(
      _tableName,
      budget.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return budget.id;
  }

  @override
  Future<void> updateBudget(BudgetModel budget) async {
    await _database.update(
      _tableName,
      budget.copyWith(updatedAt: DateTime.now()).toMap(),
      where: 'id = ?',
      whereArgs: [budget.id],
    );
  }

  @override
  Future<void> deleteBudget(String id) async {
    await _database.update(
      _tableName,
      {
        'is_active': 0,
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<int> getBudgetsCount() async {
    final result = await _database.rawQuery(
      'SELECT COUNT(*) as count FROM $_tableName WHERE is_active = 1',
    );
    return result.first['count'] as int;
  }

  @override
  Future<List<BudgetModel>> searchBudgets(String query) async {
    final List<Map<String, dynamic>> maps = await _database.query(
      _tableName,
      where: '(name LIKE ? OR description LIKE ?) AND is_active = ?',
      whereArgs: ['%$query%', '%$query%', 1],
      orderBy: 'created_at DESC',
    );

    return List.generate(maps.length, (i) => BudgetModel.fromMap(maps[i]));
  }

  @override
  Future<List<BudgetModel>> getCurrentPeriodBudgets() async {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0);

    final List<Map<String, dynamic>> maps = await _database.query(
      _tableName,
      where: '''
        is_active = 1 AND (
          (start_date <= ? AND end_date >= ?) OR
          (start_date >= ? AND start_date <= ?)
        )
      ''',
      whereArgs: [
        startOfMonth.toIso8601String(),
        endOfMonth.toIso8601String(),
        startOfMonth.toIso8601String(),
        endOfMonth.toIso8601String(),
      ],
      orderBy: 'created_at DESC',
    );

    return List.generate(maps.length, (i) => BudgetModel.fromMap(maps[i]));
  }

}