import 'package:injectable/injectable.dart';
import '../entities/category_entity.dart';
import '../repositories/category_repository.dart';

@injectable
class CreateCategory {
  final CategoryRepository _repository;

  CreateCategory(this._repository);

  Future<String> call(CategoryEntity category) async {
    return await _repository.createCategory(category);
  }
}

@injectable
class UpdateCategory {
  final CategoryRepository _repository;

  UpdateCategory(this._repository);

  Future<void> call(CategoryEntity category) async {
    await _repository.updateCategory(category);
  }
}

@injectable
class DeleteCategory {
  final CategoryRepository _repository;

  DeleteCategory(this._repository);

  Future<void> call(String id) async {
    await _repository.deleteCategory(id);
  }
}

@injectable
class InitializePredefinedCategories {
  final CategoryRepository _repository;

  InitializePredefinedCategories(this._repository);

  Future<void> call() async {
    await _repository.initializePredefinedCategories();
  }
}