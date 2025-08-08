import 'package:injectable/injectable.dart';
import '../entities/budget_entity.dart';
import '../repositories/budget_repository.dart';

@injectable
class CreateBudget {
  final BudgetRepository _repository;

  CreateBudget(this._repository);

  Future<String> call(BudgetEntity budget) async {
    return await _repository.createBudget(budget);
  }
}

@injectable
class UpdateBudget {
  final BudgetRepository _repository;

  UpdateBudget(this._repository);

  Future<void> call(BudgetEntity budget) async {
    await _repository.updateBudget(budget);
  }
}

@injectable
class DeleteBudget {
  final BudgetRepository _repository;

  DeleteBudget(this._repository);

  Future<void> call(String id) async {
    await _repository.deleteBudget(id);
  }
}