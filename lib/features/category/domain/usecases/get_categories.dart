import 'package:injectable/injectable.dart';
import '../entities/category_entity.dart';
import '../repositories/category_repository.dart';

@injectable
class GetCategories {
  final CategoryRepository _repository;

  GetCategories(this._repository);

  Future<List<CategoryEntity>> call() async {
    return await _repository.getAllCategories();
  }
}

@injectable
class GetCategoriesByType {
  final CategoryRepository _repository;

  GetCategoriesByType(this._repository);

  Future<List<CategoryEntity>> call(CategoryType type) async {
    return await _repository.getCategoriesByType(type);
  }
}