import 'package:injectable/injectable.dart';
import 'package:sqflite/sqflite.dart';
import '../database/database_service.dart';
import '../../features/transaction/domain/repositories/transaction_repository.dart';
import '../../features/budget_management/domain/repositories/budget_management_repository.dart';
import '../../features/onboarding/domain/repositories/onboarding_repository.dart';


@singleton
class DataDeletionService {
  final TransactionRepository _transactionRepository;
  final BudgetManagementRepository _budgetRepository;
  final OnboardingRepository _onboardingRepository;

  DataDeletionService(
    this._transactionRepository,
    this._budgetRepository,
    this._onboardingRepository,
  );

  
  
  
  Future<bool> clearAllData() async {
    try {
      final db = await DatabaseService.instance;
      
      
      await db.transaction((txn) async {
        
        
        
        await txn.delete('transactions');
        
        
        await txn.delete('budgets');
        
        
        await txn.delete('categories');
        
        
        await txn.delete('app_settings');
        
        
        await txn.insert('app_settings', {
          'locale': 'en',
          'currency_code': 'USD',
          'is_dark_mode': 0,
          'onboarding_completed': 0,
        });
      });
      
      return true;
    } catch (e) {
      
      return false;
    }
  }

  
  Future<bool> clearTransactions() async {
    try {
      final db = await DatabaseService.instance;
      await db.delete('transactions');
      return true;
    } catch (e) {
      return false;
    }
  }

  
  Future<bool> clearBudgets() async {
    try {
      final db = await DatabaseService.instance;
      await db.transaction((txn) async {
        
        await txn.delete('transactions');
        
        await txn.delete('budgets');
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  
  Future<bool> clearCategories() async {
    try {
      final db = await DatabaseService.instance;
      await db.transaction((txn) async {
        
        await txn.delete('transactions');
        await txn.delete('budgets');
        await txn.delete('categories');
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  
  Future<bool> resetAppSettings() async {
    try {
      final db = await DatabaseService.instance;
      await db.transaction((txn) async {
        await txn.delete('app_settings');
        await txn.insert('app_settings', {
          'locale': 'en',
          'currency_code': 'USD',
          'is_dark_mode': 0,
          'onboarding_completed': 0,
        });
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  
  Future<DataStatistics> getDataStatistics() async {
    try {
      final db = await DatabaseService.instance;
      
      final transactionCount = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM transactions')
      ) ?? 0;
      
      final budgetCount = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM budgets')
      ) ?? 0;
      
      final categoryCount = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM categories')
      ) ?? 0;
      
      return DataStatistics(
        transactionCount: transactionCount,
        budgetCount: budgetCount,
        categoryCount: categoryCount,
      );
    } catch (e) {
      return DataStatistics(
        transactionCount: 0,
        budgetCount: 0,
        categoryCount: 0,
      );
    }
  }

  
  Future<bool> hasUserData() async {
    final stats = await getDataStatistics();
    return stats.transactionCount > 0 || 
           stats.budgetCount > 0 || 
           stats.categoryCount > 0;
  }
}


class DataStatistics {
  final int transactionCount;
  final int budgetCount;
  final int categoryCount;

  DataStatistics({
    required this.transactionCount,
    required this.budgetCount,
    required this.categoryCount,
  });

  int get totalItems => transactionCount + budgetCount + categoryCount;
}