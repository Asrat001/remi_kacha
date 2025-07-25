import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';
import 'package:sqflite_sqlcipher/sqlite_api.dart';
import 'secure_storage_service.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._privateConstructor();
  static Database? _database;

  final _dbName = "secure_app.db";

  DatabaseService._privateConstructor();

  Future<Database> get database async {
    return _database ??= await _initDatabase();
  }

  Future<Database> _initDatabase() async {
    final documentsDir = await getApplicationDocumentsDirectory();
    final path = join(documentsDir.path, _dbName);

    // Load password securely
    String? password = await SecureStorageService.getDbPassword();

    if (password == null) {
      // Generate and store password securely
      password = _generateRandomPassword();
      await SecureStorageService.saveDbPassword(password);
    }

    return await openDatabase(
      path,
      password: password,
      version: 3,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT ,
        email TEXT,
        phoneNumber TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        pin TEXT ,
        currency TEXT
      )
    ''');
        await db.execute('''
      CREATE TABLE wallets (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        balance REAL NOT NULL,
        currency TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users (id)
      )
    ''');
        await db.execute('''
      CREATE TABLE transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        sender_id INTEGER NOT NULL,
        recipient TEXT NOT NULL,
        bank TEXT,
        account_no TEXT,
        amount REAL NOT NULL,
        currency TEXT NOT NULL,
        timestamp TEXT NOT NULL,
        FOREIGN KEY (sender_id) REFERENCES users (id)
      )
    ''');
    await db.execute('''
  CREATE TABLE exchange_rates (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    currency_code TEXT NOT NULL,
    rate REAL NOT NULL,
    timestamp TEXT NOT NULL
  )
''');
  }
  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 3) {
      // Create a new table without UNIQUE constraint on email
      await db.execute('''
        CREATE TABLE temp_users (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          email TEXT, -- Removed UNIQUE constraint
          phoneNumber TEXT NOT NULL UNIQUE,
          password TEXT NOT NULL,
          pin TEXT
          currency TEXT
        )
      ''');

      // 2. Copy existing data (add null for missing column)
      await db.execute('''
      INSERT INTO temp_users (id, name, email, phoneNumber, password, pin, currency)
      SELECT id, name, email, phoneNumber, password, pin, NULL FROM users
    ''');

      // Drop the old users table
      await db.execute('DROP TABLE users');

      // Rename temp_users to users
      await db.execute('ALTER TABLE temp_users RENAME TO users');
    }
  }

  String _generateRandomPassword() {
    final now = DateTime.now().millisecondsSinceEpoch;
    return 'pass_$now'; 
  }

  Future<void> clearTableIfExists(String tableName) async {
    final db = await database;

    final result = await db.rawQuery('''
    SELECT name FROM sqlite_master 
    WHERE type='table' AND name=?
  ''', [tableName]);

    if (result.isNotEmpty) {
      await db.delete(tableName); // Clears all rows
      print('✅ Table "$tableName" emptied.');
    } else {
      print('⚠️ Table "$tableName" does not exist.');
    }
  }

 
}
