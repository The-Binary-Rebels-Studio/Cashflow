import '../entities/category_entity.dart';

abstract class CategoryRepository {
  Future<List<CategoryEntity>> getAllCategories();
  Future<List<CategoryEntity>> getCategoriesByType(CategoryType type);
  Future<CategoryEntity?> getCategoryById(String id);
  Future<String> createCategory(CategoryEntity category);
  Future<void> updateCategory(CategoryEntity category);
  Future<void> deleteCategory(String id);
  Future<void> initializePredefinedCategories();
  Future<int> getCategoriesCount();
  Future<List<CategoryEntity>> searchCategories(String query);
}