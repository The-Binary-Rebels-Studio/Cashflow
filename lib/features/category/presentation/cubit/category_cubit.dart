import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/usecases/get_categories.dart';
import '../../domain/usecases/manage_category.dart';
import 'category_state.dart';

@injectable
class CategoryCubit extends Cubit<CategoryState> {
  final GetCategories _getCategories;
  final GetCategoriesByType _getCategoriesByType;
  final CreateCategory _createCategory;
  final UpdateCategory _updateCategory;
  final DeleteCategory _deleteCategory;
  final InitializePredefinedCategories _initializePredefinedCategories;

  CategoryCubit(
    this._getCategories,
    this._getCategoriesByType,
    this._createCategory,
    this._updateCategory,
    this._deleteCategory,
    this._initializePredefinedCategories,
  ) : super(CategoryInitial());

  Future<void> initializeCategories() async {
    try {
      emit(CategoryLoading());
      
      // Initialize predefined categories if not already done
      await _initializePredefinedCategories();
      
      // Load all categories
      await loadCategories();
    } catch (e) {
      emit(CategoryError('Failed to initialize categories: ${e.toString()}'));
    }
  }

  Future<void> loadCategories() async {
    try {
      emit(CategoryLoading());
      
      final allCategories = await _getCategories();
      final incomeCategories = await _getCategoriesByType(CategoryType.income);
      final expenseCategories = await _getCategoriesByType(CategoryType.expense);
      
      emit(CategoryLoaded(
        categories: allCategories,
        incomeCategories: incomeCategories,
        expenseCategories: expenseCategories,
      ));
    } catch (e) {
      emit(CategoryError('Failed to load categories: ${e.toString()}'));
    }
  }

  Future<void> createNewCategory(CategoryEntity category) async {
    try {
      emit(CategoryLoading());
      
      await _createCategory(category);
      emit(const CategoryOperationSuccess('Category created successfully'));
      
      // Reload categories
      await loadCategories();
    } catch (e) {
      emit(CategoryError('Failed to create category: ${e.toString()}'));
    }
  }

  Future<void> updateExistingCategory(CategoryEntity category) async {
    try {
      emit(CategoryLoading());
      
      await _updateCategory(category);
      emit(const CategoryOperationSuccess('Category updated successfully'));
      
      // Reload categories
      await loadCategories();
    } catch (e) {
      emit(CategoryError('Failed to update category: ${e.toString()}'));
    }
  }

  Future<void> deleteExistingCategory(String id) async {
    try {
      emit(CategoryLoading());
      
      await _deleteCategory(id);
      emit(const CategoryOperationSuccess('Category deleted successfully'));
      
      // Reload categories
      await loadCategories();
    } catch (e) {
      emit(CategoryError('Failed to delete category: ${e.toString()}'));
    }
  }

  List<CategoryEntity> getCategoriesByType(CategoryType type) {
    final currentState = state;
    if (currentState is CategoryLoaded) {
      return type == CategoryType.income 
        ? currentState.incomeCategories
        : currentState.expenseCategories;
    }
    return [];
  }
}