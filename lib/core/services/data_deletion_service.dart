import 'package:injectable/injectable.dart';
import 'package:sqflite/sqflite.dart';
import '../database/database_service.dart';
import '../../features/transaction/domain/repositories/transaction_repository.dart';
import '../../features/budget_management/domain/repositories/budget_management_repository.dart';
import '../../features/onboarding/domain/repositories/onboarding_repository.dart';

/// Service responsible for clearing all user data from the application
/// This includes transactions, budgets, categories, and app settings
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

  /// Clear all user data from the application
  /// This will delete transactions, budgets, categories, and reset app settings
  /// Returns true if successful, false if any error occurred
  Future<bool> clearAllData() async {
    try {
      final db = await DatabaseService.instance;
      
      // Start a transaction to ensure all deletions are atomic
      await db.transaction((txn) async {
        // Delete in proper order to respect foreign key constraints
        
        // 1. Delete all transactions first (child table)
        await txn.delete('transactions');
        
        // 2. Delete all budgets (references categories)
        await txn.delete('budgets');
        
        // 3. Delete all categories
        await txn.delete('categories');
        
        // 4. Clear app settings but keep the record structure
        await txn.delete('app_settings');
        
        // Insert default app settings
        await txn.insert('app_settings', {
          'locale': 'en',
          'currency_code': 'USD',
          'is_dark_mode': 0,
          'onboarding_completed': 0,
        });
      });
      
      return true;
    } catch (e) {
      // Log error but don't rethrow to avoid crashes
      return false;
    }
  }

  /// Clear only transaction data
  Future<bool> clearTransactions() async {
    try {
      final db = await DatabaseService.instance;
      await db.delete('transactions');
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Clear only budget data (this will also clear transactions due to foreign key constraints)
  Future<bool> clearBudgets() async {
    try {
      final db = await DatabaseService.instance;
      await db.transaction((txn) async {
        // Delete transactions first due to foreign key constraint
        await txn.delete('transactions');
        // Then delete budgets
        await txn.delete('budgets');
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Clear only categories (this will also clear budgets and transactions)
  Future<bool> clearCategories() async {
    try {
      final db = await DatabaseService.instance;
      await db.transaction((txn) async {
        // Delete in proper order due to foreign key constraints
        await txn.delete('transactions');
        await txn.delete('budgets');
        await txn.delete('categories');
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Reset app settings to defaults
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

  /// Get data statistics for confirmation dialog
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

  /// Check if there is any user data in the app
  Future<bool> hasUserData() async {
    final stats = await getDataStatistics();
    return stats.transactionCount > 0 || 
           stats.budgetCount > 0 || 
           stats.categoryCount > 0;
  }
}

/// Data class to hold statistics about user data
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