import 'package:injectable/injectable.dart';
import '../entities/budget_entity.dart';
import '../repositories/budget_repository.dart';

@injectable
class GetBudgets {
  final BudgetRepository _repository;

  GetBudgets(this._repository);

  Future<List<BudgetEntity>> call() async {
    return await _repository.getAllBudgets();
  }
}

@injectable
class GetActiveBudgets {
  final BudgetRepository _repository;

  GetActiveBudgets(this._repository);

  Future<List<BudgetEntity>> call() async {
    return await _repository.getActiveBudgets();
  }
}

@injectable
class GetBudgetsByPeriod {
  final BudgetRepository _repository;

  GetBudgetsByPeriod(this._repository);

  Future<List<BudgetEntity>> call(BudgetPeriod period) async {
    return await _repository.getBudgetsByPeriod(period);
  }
}

@injectable
class GetCurrentPeriodBudgets {
  final BudgetRepository _repository;

  GetCurrentPeriodBudgets(this._repository);

  Future<List<BudgetEntity>> call() async {
    return await _repository.getCurrentPeriodBudgets();
  }
}