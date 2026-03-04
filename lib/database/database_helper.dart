import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('checkout.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const integerType = 'INTEGER NOT NULL';
    const realType = 'REAL NOT NULL';

    // 1. Users Table
    await db.execute('''
CREATE TABLE users (
  id $idType,
  name $textType,
  password $textType
)
''');

    // 2. Payment Methods Table
    await db.execute('''
CREATE TABLE payment_methods (
  id $idType,
  user_id $integerType,
  card_type $textType,
  card_holder $textType,
  last4 $textType,
  FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
)
''');

    // 3. Purchases Table
    await db.execute('''
CREATE TABLE purchases (
  id $idType,
  user_id $integerType,
  total $realType,
  date $textType,
  FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
)
''');

    // 4. Purchase Items Table
    await db.execute('''
CREATE TABLE purchase_items (
  id $idType,
  purchase_id $integerType,
  product_name $textType,
  price $realType,
  FOREIGN KEY (purchase_id) REFERENCES purchases (id) ON DELETE CASCADE
)
''');
  }

  // --- Helper Methods ---

  // User
  Future<int> createUser(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert('users', row);
  }

  Future<Map<String, dynamic>?> getUser(String name, String password) async {
    final db = await instance.database;
    final maps = await db.query(
      'users',
      where: 'name = ? AND password = ?',
      whereArgs: [name, password],
    );

    if (maps.isNotEmpty) {
      return maps.first;
    } else {
      return null;
    }
  }

  // Payment Methods
  Future<int> createPaymentMethod(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert('payment_methods', row);
  }

  Future<List<Map<String, dynamic>>> getPaymentMethods(int userId) async {
    final db = await instance.database;
    return await db.query(
      'payment_methods',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
  }

  // Purchases
  Future<int> createPurchase(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert('purchases', row);
  }

  Future<int> createPurchaseItem(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert('purchase_items', row);
  }
  
  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
