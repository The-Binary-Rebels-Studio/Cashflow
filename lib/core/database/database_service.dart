import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseService {
  static Database? _database;
  static const int _currentVersion = 1;

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
    
    await db.execute('''
      CREATE TABLE categories(
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        description TEXT,
        icon_code_point TEXT NOT NULL,
        color_value TEXT NOT NULL,
        type TEXT NOT NULL CHECK (type IN ('income', 'expense')),
        is_active INTEGER NOT NULL DEFAULT 1,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');
    
    // Create index for better query performance
    await db.execute('CREATE INDEX idx_categories_type ON categories(type)');
    await db.execute('CREATE INDEX idx_categories_active ON categories(is_active)');
    
    await db.execute('''
      CREATE TABLE budgets(
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        description TEXT,
        category_id TEXT NOT NULL,
        amount REAL NOT NULL,
        period TEXT NOT NULL CHECK (period IN ('weekly', 'monthly', 'quarterly', 'yearly')),
        start_date TEXT NOT NULL,
        end_date TEXT NOT NULL,
        is_active INTEGER NOT NULL DEFAULT 1,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        FOREIGN KEY (category_id) REFERENCES categories (id)
      )
    ''');
    
    // Create indexes for budgets
    await db.execute('CREATE INDEX idx_budgets_category ON budgets(category_id)');
    await db.execute('CREATE INDEX idx_budgets_period ON budgets(period)');
    await db.execute('CREATE INDEX idx_budgets_active ON budgets(is_active)');
    await db.execute('CREATE INDEX idx_budgets_dates ON budgets(start_date, end_date)');
    
    await db.execute('''
      CREATE TABLE transactions(
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT,
        amount REAL NOT NULL,
        category_id TEXT NOT NULL,
        type TEXT NOT NULL CHECK (type IN ('income', 'expense')),
        date TEXT NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        FOREIGN KEY (category_id) REFERENCES categories (id)
      )
    ''');
    
    // Create indexes for transactions
    await db.execute('CREATE INDEX idx_transactions_category ON transactions(category_id)');
    await db.execute('CREATE INDEX idx_transactions_type ON transactions(type)');
    await db.execute('CREATE INDEX idx_transactions_date ON transactions(date)');
    await db.execute('CREATE INDEX idx_transactions_date_category ON transactions(date, category_id)');
  }

  static Future<void> _migrateToVersion(Database db, int version) async {
    switch (version) {
      // Migration logic will be added here when app is released
      // For now, all tables are created in onCreate
      default:
        break;
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