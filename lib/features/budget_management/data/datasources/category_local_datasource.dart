import 'package:sqflite/sqflite.dart';
import 'package:injectable/injectable.dart';
import '../models/category_model.dart';
import '../../domain/entities/category_entity.dart';

abstract class CategoryLocalDataSource {
  Future<List<CategoryModel>> getAllCategories();
  Future<List<CategoryModel>> getCategoriesByType(CategoryType type);
  Future<CategoryModel?> getCategoryById(String id);
  Future<String> insertCategory(CategoryModel category);
  Future<void> updateCategory(CategoryModel category);
  Future<void> deleteCategory(String id);
  Future<void> initializePredefinedCategories();
  Future<int> getCategoriesCount();
  Future<List<CategoryModel>> searchCategories(String query);
}

@Injectable(as: CategoryLocalDataSource)
class CategoryLocalDataSourceImpl implements CategoryLocalDataSource {
  final Database _database;

  CategoryLocalDataSourceImpl(this._database);

  static const String _tableName = 'categories';

  @override
  Future<List<CategoryModel>> getAllCategories() async {
    final List<Map<String, dynamic>> maps = await _database.query(
      _tableName,
      where: 'is_active = ?',
      whereArgs: [1],
      orderBy: 'name ASC',
    );

    return List.generate(maps.length, (i) => CategoryModel.fromMap(maps[i]));
  }

  @override
  Future<List<CategoryModel>> getCategoriesByType(CategoryType type) async {
    final List<Map<String, dynamic>> maps = await _database.query(
      _tableName,
      where: 'type = ? AND is_active = ?',
      whereArgs: [type.value, 1],
      orderBy: 'name ASC',
    );

    return List.generate(maps.length, (i) => CategoryModel.fromMap(maps[i]));
  }

  @override
  Future<CategoryModel?> getCategoryById(String id) async {
    final List<Map<String, dynamic>> maps = await _database.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (maps.isEmpty) return null;
    return CategoryModel.fromMap(maps.first);
  }

  @override
  Future<String> insertCategory(CategoryModel category) async {
    await _database.insert(
      _tableName,
      category.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return category.id;
  }

  @override
  Future<void> updateCategory(CategoryModel category) async {
    await _database.update(
      _tableName,
      category.copyWith(updatedAt: DateTime.now()).toMap(),
      where: 'id = ?',
      whereArgs: [category.id],
    );
  }

  @override
  Future<void> deleteCategory(String id) async {
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
  Future<int> getCategoriesCount() async {
    final result = await _database.rawQuery(
      'SELECT COUNT(*) as count FROM $_tableName WHERE is_active = 1',
    );
    return result.first['count'] as int;
  }

  @override
  Future<List<CategoryModel>> searchCategories(String query) async {
    final List<Map<String, dynamic>> maps = await _database.query(
      _tableName,
      where: 'name LIKE ? AND is_active = ?',
      whereArgs: ['%$query%', 1],
      orderBy: 'name ASC',
    );

    return List.generate(maps.length, (i) => CategoryModel.fromMap(maps[i]));
  }

  @override
  Future<void> initializePredefinedCategories() async {
    final count = await getCategoriesCount();
    if (count > 0) return; // Already initialized

    final batch = _database.batch();
    final now = DateTime.now();

    // Add expense categories
    for (final categoryData in PredefinedCategories.expenseCategories) {
      final category = CategoryModel(
        id: _generateId(),
        name: categoryData['name'] as String,
        description: categoryData['description'] as String,
        iconCodePoint: categoryData['icon_code_point'] as String,
        colorValue: categoryData['color_value'] as String,
        type: CategoryType.expense,
        isActive: true,
        createdAt: now,
        updatedAt: now,
      );
      batch.insert(_tableName, category.toMap());
    }

    // Add income categories
    for (final categoryData in PredefinedCategories.incomeCategories) {
      final category = CategoryModel(
        id: _generateId(),
        name: categoryData['name'] as String,
        description: categoryData['description'] as String,
        iconCodePoint: categoryData['icon_code_point'] as String,
        colorValue: categoryData['color_value'] as String,
        type: CategoryType.income,
        isActive: true,
        createdAt: now,
        updatedAt: now,
      );
      batch.insert(_tableName, category.toMap());
    }

    await batch.commit();
  }

  String _generateId() {
    return 'cat_${DateTime.now().millisecondsSinceEpoch}_${(DateTime.now().microsecond % 1000)}';
  }
}