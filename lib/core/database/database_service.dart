import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseService {
  static Database? _database;
  static const int _currentVersion = 2;

  static Future<Database> get instance async {
    if (_database != null) return _database!;

    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'cashflow.db');
    
    _database = await openDatabase(
      path,
      version: _currentVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
    return _database!;
  }

  static Future<void> _onCreate(Database db, int version) async {
    await _createAllTables(db);
  }

  static Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    for (int version = oldVersion + 1; version <= newVersion; version++) {
      await _migrateToVersion(db, version);
    }
  }

  static Future<void> _createAllTables(Database db) async {
    await db.execute('''
      CREATE TABLE app_settings(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        locale TEXT,
        currency_code TEXT,
        is_dark_mode INTEGER,
        onboarding_completed INTEGER DEFAULT 0
      )
    ''');
    
    // Add other table creations here
  }

  static Future<void> _migrateToVersion(Database db, int version) async {
    switch (version) {
      case 2:
        // Add onboarding_completed column to existing app_settings table
        await db.execute('ALTER TABLE app_settings ADD COLUMN onboarding_completed INTEGER DEFAULT 0');
        break;
      case 3:
        // Example migration to version 3  
        // await db.execute('CREATE TABLE transactions(id INTEGER PRIMARY KEY, amount REAL, date TEXT)');
        break;
      // Add more migrations as needed
    }
  }

  Future<String?> getString(String key) async {
    final db = await instance;
    final result = await db.query(
      'app_settings',
      columns: [key],
      limit: 1,
    );
    
    if (result.isNotEmpty && result.first[key] != null) {
      return result.first[key] as String;
    }
    return null;
  }

  Future<void> setString(String key, String value) async {
    final db = await instance;
    
    final existing = await db.query('app_settings', limit: 1);
    
    if (existing.isEmpty) {
      await db.insert('app_settings', {key: value});
    } else {
      await db.update(
        'app_settings',
        {key: value},
        where: 'id = ?',
        whereArgs: [existing.first['id']],
      );
    }
  }

  static Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}