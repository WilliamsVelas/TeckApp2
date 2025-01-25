import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:teck_app/app/database/models/products_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  static const String _dbName = 'teckapp_database.db';
  static const int _dbVersion = 1;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE products (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      code TEXT,
      price REAL DEFAULT 0.0,
      refPrice REAL,
      status TEXT DEFAULT 'activo' CHECK (status IN ('activo', 'inactivo', 'vendido', 'afectado')),
      minStock INTEGER DEFAULT 0,
      serialsQty INTEGER DEFAULT 0,
      categoryId INTEGER DEFAULT 0,
      providerId INTEGER DEFAULT 0,
      createdAt TEXT,
      updatedAt TEXT
    )
  ''');
  }

  Future<void> close() async {
    final db = await database;
    db.close();
  }

  //Product
  Future<int> insertProduct(Product product) async {
    final db = await database;
    return await db.insert('products', product.toMap());
  }

  Future<List<Product>> getProducts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('products');

    return List.generate(maps.length, (i) {
      return Product.fromMap(maps[i]);
    });
  }

  Future<int> updateProduct(Product product) async {
    final db = await database;
    product.updatedAt = DateTime.now();
    return await db.update(
      'products',
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }


}
