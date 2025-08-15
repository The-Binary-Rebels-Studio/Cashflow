import 'package:injectable/injectable.dart';
import 'package:cashflow/core/database/database_service.dart';

abstract class OnboardingLocalDataSource {
  Future<bool> isOnboardingCompleted();
  Future<void> setOnboardingCompleted(bool completed);
}

@Injectable(as: OnboardingLocalDataSource)
class OnboardingLocalDataSourceImpl implements OnboardingLocalDataSource {
  static const String _tableName = 'app_settings';
  
  @override
  Future<bool> isOnboardingCompleted() async {
    try {
      final db = await DatabaseService.instance;
      final result = await db.query(
        _tableName,
        where: 'onboarding_completed = ?',
        whereArgs: [1],
        limit: 1,
      );
      
      return result.isNotEmpty;
    } catch (e) {
      
      return false;
    }
  }
  
  @override
  Future<void> setOnboardingCompleted(bool completed) async {
    final db = await DatabaseService.instance;
    
    try {
      
      final existing = await db.query(_tableName, limit: 1);
      
      if (existing.isNotEmpty) {
        
        await db.update(
          _tableName,
          {'onboarding_completed': completed ? 1 : 0},
          where: 'id = ?',
          whereArgs: [existing.first['id']],
        );
      } else {
        
        await db.insert(
          _tableName,
          {
            'onboarding_completed': completed ? 1 : 0,
            'locale': null,
            'is_dark_mode': null,
          },
        );
      }
    } catch (e) {
      
      
      await DatabaseService.close();
      final newDb = await DatabaseService.instance;
      
      
      final existing = await newDb.query(_tableName, limit: 1);
      
      if (existing.isNotEmpty) {
        await newDb.update(
          _tableName,
          {'onboarding_completed': completed ? 1 : 0},
          where: 'id = ?',
          whereArgs: [existing.first['id']],
        );
      } else {
        await newDb.insert(
          _tableName,
          {
            'onboarding_completed': completed ? 1 : 0,
            'locale': null,
            'is_dark_mode': null,
          },
        );
      }
    }
  }
}