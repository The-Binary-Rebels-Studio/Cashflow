import 'package:injectable/injectable.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/repositories/category_repository.dart';
import '../datasources/category_local_datasource.dart';
import '../models/category_model.dart';

@Injectable(as: CategoryRepository)
class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryLocalDataSource _localDataSource;

  CategoryRepositoryImpl({required CategoryLocalDataSource localDataSource})
      : _localDataSource = localDataSource;

  @override
  Future<List<CategoryEntity>> getAllCategories() async {
    final categories = await _localDataSource.getAllCategories();
    return categories.map((model) => model as CategoryEntity).toList();
  }

  @override
  Future<List<CategoryEntity>> getCategoriesByType(CategoryType type) async {
    final categories = await _localDataSource.getCategoriesByType(type);
    return categories.map((model) => model as CategoryEntity).toList();
  }

  @override
  Future<CategoryEntity?> getCategoryById(String id) async {
    final category = await _localDataSource.getCategoryById(id);
    return category;
  }

  @override
  Future<String> createCategory(CategoryEntity category) async {
    final categoryModel = CategoryModel.fromEntity(category);
    return await _localDataSource.insertCategory(categoryModel);
  }

  @override
  Future<void> updateCategory(CategoryEntity category) async {
    final categoryModel = CategoryModel.fromEntity(category);
    await _localDataSource.updateCategory(categoryModel);
  }

  @override
  Future<void> deleteCategory(String id) async {
    await _localDataSource.deleteCategory(id);
  }

  @override
  Future<void> initializePredefinedCategories() async {
    await _localDataSource.initializePredefinedCategories();
  }

  @override
  Future<int> getCategoriesCount() async {
    return await _localDataSource.getCategoriesCount();
  }

  @override
  Future<List<CategoryEntity>> searchCategories(String query) async {
    final categories = await _localDataSource.searchCategories(query);
    return categories.map((model) => model as CategoryEntity).toList();
  }
}