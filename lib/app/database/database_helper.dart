import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:teck_app/app/database/models/products_model.dart';

import 'models/categories_model.dart';
import 'models/clients_model.dart';
import 'models/payment_method_model.dart';
import 'models/providers_model.dart';

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
    //products table
    await db.execute('''
    CREATE TABLE products (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      code TEXT,
      price REAL DEFAULT 0.0,
      refPrice REAL,
      status TEXT DEFAULT 'activo' CHECK (status IN ('activo', 'inactivo', 'vendido', 'afectado')),
      minStock INTEGER,
      imageId INTEGER,
      serialsQty INTEGER,
      categoryId INTEGER,
      providerId INTEGER,
      createdAt TEXT,
      updatedAt TEXT
    )
  ''');

    //categories table
    await db.execute('''
    CREATE TABLE categories (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      code TEXT,
      createdAt TEXT,
      updatedAt TEXT
    )
  ''');

    //payment methods table
    await db.execute('''
    CREATE TABLE paymentMethods (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      code TEXT,
      createdAt TEXT,
      updatedAt TEXT
    )
  ''');

    //user table
    await db.execute('''
    CREATE TABLE users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      lastName TEXT,
      username TEXT,
      password TEXT,
      amount REAL,
      createdAt TEXT,
      updatedAt TEXT
    )
  ''');

    //clients table
    await db.execute('''
    CREATE TABLE clients (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      lastName TEXT,
      businessName TEXT,
      bankAccount TEXT,
      codeBank TEXT,
      affiliateCode TEXT,
      value TEXT,
      createdAt TEXT,
      updatedAt TEXT
    )
  ''');

    //providers table
    await db.execute('''
    CREATE TABLE providers (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      lastName TEXT,
      businessName TEXT,
      value TEXT,
      createdAt TEXT,
      updatedAt TEXT
    )
  ''');

    //images table
    await db.execute('''
    CREATE TABLE images (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      uri TEXT,
      createdAt TEXT,
      updatedAt TEXT
    )
  ''');

    //serials table
    await db.execute('''
    CREATE TABLE serials (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      productId INTEGER,
      serial TEXT,
      createdAt TEXT,
      updatedAt TEXT
    )
  ''');

    //bank account table
    await db.execute('''
    CREATE TABLE banckAccounts (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      bankName TEXT,
      numberAccount TEXT,
      code TEXT,
      clientId INTEGER,
      createdAt TEXT,
      updatedAt TEXT
    )
  ''');

    //invoices table
    await db.execute('''
    CREATE TABLE invoices (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      documentNo TEXT,
      type TEXT,
      totalAmount REAL,
      totalPayed REAL,
      refTotalAmount REAL,
      refTotalPayed REAL,
      qty INTEGER
      clientId INTEGER
      bankAccountId INTEGER
      productId INTEGER,
      createdAt TEXT,
      updatedAt TEXT
    )
  ''');

    //invoice line table
    await db.execute('''
    CREATE TABLE invoiceLine (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      productName TEXT,
      productPrice REAL,
      refProductPrice REAL,
      total REAL,
      refTotal REAL,
      productId INTEGER,
      productSerial TEXT,
      invoiceId INTEGER,
      createdAt TEXT,
      updatedAt TEXT
    )
  ''');
  }

  Future<void> close() async {
    final db = await database;
    db.close();
  }

  //Products
  //Insert product
  Future<int> insertProduct(Product product) async {
    final db = await database;
    return await db.insert('products', product.toMap());
  }

  //Get products
  Future<List<Product>> getProducts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('products');

    return List.generate(maps.length, (i) {
      return Product.fromMap(maps[i]);
    });
  }

  //Update product
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

  //Desactive product
  Future<int> desactiveProduct(Product product) async {
    final db = await database;
    product.status = 'inactivo';
    product.updatedAt = DateTime.now();

    return await db.update(
      'products',
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  //Get product by id
  Future<Product?> getProductById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'products',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (maps.isNotEmpty) {
      return Product.fromMap(maps.first);
    } else {
      return null;
    }
  }

  // Categories
  // Insert category
  Future<int> insertCategory(Category category) async {
    final db = await database;
    return await db.insert('categories', category.toMap());
  }

  // Get all categories
  Future<List<Category>> getCategories() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('categories');

    return List.generate(maps.length, (i) {
      return Category.fromMap(maps[i]);
    });
  }

  // Update category
  Future<int> updateCategory(Category category) async {
    final db = await database;
    return await db.update(
      'categories',
      category.toMap(),
      where: 'id = ?',
      whereArgs: [category.id],
    );
  }

  // Get category by ID
  Future<Category?> getCategoryById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'categories',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (maps.isNotEmpty) {
      return Category.fromMap(maps.first);
    } else {
      return null;
    }
  }

  // Payment Methods
  // Insert payment method
  Future<int> insertPaymentMethod(PaymentMethod paymentMethod) async {
    final db = await database;
    return await db.insert('paymentMethods', paymentMethod.toMap());
  }

  // Get all payment methods
  Future<List<PaymentMethod>> getPaymentMethods() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('paymentMethods');

    return List.generate(maps.length, (i) {
      return PaymentMethod.fromMap(maps[i]);
    });
  }

  // Update payment method
  Future<int> updatePaymentMethod(PaymentMethod paymentMethod) async {
    final db = await database;
    return await db.update(
      'paymentMethods',
      paymentMethod.toMap(),
      where: 'id = ?',
      whereArgs: [paymentMethod.id],
    );
  }

  //Desactive payment method
  Future<int> desactivePaymentMethod(PaymentMethod paymentMethod) async {
    final db = await database;
    paymentMethod.updatedAt = DateTime.now();

    return await db.update(
      'paymentMethods',
      paymentMethod.toMap(),
      where: 'id = ?',
      whereArgs: [paymentMethod.id],
    );
  }

  // Get payment method by ID
  Future<PaymentMethod?> getPaymentMethodById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'paymentMethods',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (maps.isNotEmpty) {
      return PaymentMethod.fromMap(maps.first);
    } else {
      return null;
    }
  }

  // Clients
  // Insert client
  Future<int> insertClient(Client client) async {
    final db = await database;
    return await db.insert('clients', client.toMap());
  }

  // Get all clients
  Future<List<Client>> getClients() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('clients');

    return List.generate(maps.length, (i) {
      return Client.fromMap(maps[i]);
    });
  }

  // Update client
  Future<int> updateClient(Client client) async {
    final db = await database;
    return await db.update(
      'clients',
      client.toMap(),
      where: 'id = ?',
      whereArgs: [client.id],
    );
  }

  //Desactive client (actualiza solo el timestamp)
  Future<int> desactiveClient(Client client) async {
    final db = await database;
    client.updatedAt = DateTime.now();

    return await db.update(
      'clients',
      client.toMap(),
      where: 'id = ?',
      whereArgs: [client.id],
    );
  }

  // Get client by ID
  Future<Client?> getClientById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'clients',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (maps.isNotEmpty) {
      return Client.fromMap(maps.first);
    } else {
      return null;
    }
  }

  // Providers
  // Insert provider
  Future<int> insertProvider(Provider provider) async {
    final db = await database;
    return await db.insert('providers', provider.toMap());
  }

  // Get all providers
  Future<List<Provider>> getProviders() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('providers');

    return List.generate(maps.length, (i) {
      return Provider.fromMap(maps[i]);
    });
  }

  // Update provider
  Future<int> updateProvider(Provider provider) async {
    final db = await database;
    return await db.update(
      'providers',
      provider.toMap(),
      where: 'id = ?',
      whereArgs: [provider.id],
    );
  }

  Future<int> desactiveProvider(Provider provider) async {
    final db = await database;
    provider.updatedAt = DateTime.now();

    return await db.update(
      'providers',
      provider.toMap(),
      where: 'id = ?',
      whereArgs: [provider.id],
    );
  }

  // Get provider by ID
  Future<Provider?> getProviderById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'providers',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (maps.isNotEmpty) {
      return Provider.fromMap(maps.first);
    } else {
      return null;
    }
  }
}
