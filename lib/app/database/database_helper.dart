import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:teck_app/app/database/models/products_model.dart';

import 'models/bank_account_model.dart';
import 'models/categories_model.dart';
import 'models/clients_model.dart';
import 'models/invoice_lines_model.dart';
import 'models/invoices_model.dart';
import 'models/payment_method_model.dart';
import 'models/providers_model.dart';
import 'models/serials_model.dart';
import 'models/user_model.dart';

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
    // products table
    await db.execute('''
    CREATE TABLE products (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      code TEXT,
      price REAL DEFAULT 0.0,
      refPrice REAL,
      minStock INTEGER,
      imageId INTEGER,
      serialsQty INTEGER,
      categoryId INTEGER,
      providerId INTEGER,
      createdAt INTEGER,
      updatedAt INTEGER,
      isActive INTEGER DEFAULT 1
    )
  ''');

    // categories table
    await db.execute('''
    CREATE TABLE categories (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      code TEXT,
      createdAt INTEGER,
      updatedAt INTEGER,
      isActive INTEGER DEFAULT 1
    )
  ''');

    // payment methods table
    await db.execute('''
    CREATE TABLE paymentMethods (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      code TEXT,
      createdAt INTEGER,
      updatedAt INTEGER,
      isActive INTEGER DEFAULT 1
    )
  ''');

    // user table
    await db.execute('''
    CREATE TABLE users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      lastName TEXT,
      username TEXT,
      createdAt INTEGER,
      updatedAt INTEGER,
      isActive INTEGER DEFAULT 1
    )
  ''');

    // clients table
    await db.execute('''
    CREATE TABLE clients (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      lastName TEXT,
      businessName TEXT,
      affiliateCode TEXT,
      value TEXT,
      createdAt INTEGER,
      updatedAt INTEGER,
      isActive INTEGER DEFAULT 1
    )
  ''');

    // providers table
    await db.execute('''
    CREATE TABLE providers (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      lastName TEXT,
      businessName TEXT,
      value TEXT,
      createdAt INTEGER,
      updatedAt INTEGER,
      isActive INTEGER DEFAULT 1
    )
  ''');

    // images table
    await db.execute('''
    CREATE TABLE images (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      uri TEXT,
      createdAt INTEGER,
      updatedAt INTEGER,
      isActive INTEGER DEFAULT 1
    )
  ''');

    // serials table
    await db.execute('''
    CREATE TABLE serials (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      productId INTEGER,
      serial TEXT,
      status TEXT,
      createdAt INTEGER,
      updatedAt INTEGER,
      isActive INTEGER DEFAULT 1
    )
  ''');

    // bank account table
    await db.execute('''
    CREATE TABLE banckAccounts (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      bankName TEXT,
      numberAccount TEXT,
      code TEXT,
      clientId INTEGER,
      createdAt INTEGER,
      updatedAt INTEGER,
      isActive INTEGER DEFAULT 1
    )
  ''');

    // invoices table
    await db.execute('''
    CREATE TABLE invoices (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      documentNo TEXT,
      type TEXT,
      totalAmount REAL,
      totalPayed REAL,
      refTotalAmount REAL,
      refTotalPayed REAL,
      clientId INTEGER,
      createdAt INTEGER,
      updatedAt INTEGER,
      isActive INTEGER DEFAULT 1
    )
  ''');

    // invoice line table
    await db.execute('''
    CREATE TABLE invoiceLine (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      productName TEXT,
      productPrice REAL,
      refProductPrice REAL,
      total REAL,
      refTotal REAL,
      qty INTEGER,
      productId INTEGER,
      productSerial TEXT,
      invoiceId INTEGER,
      createdAt INTEGER,
      updatedAt INTEGER,
      isActive INTEGER DEFAULT 1
    )
  ''');
  }

  Future<void> close() async {
    final db = await database;
    db.close();
  }

  // Products
  Future<int> insertProduct(Product product) async {
    final db = await database;
    product.isActive = true;
    return await db.insert('products', product.toMap());
  }

  Future<List<Product>> getProducts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'products',
      where: 'isActive = 1',
      orderBy: 'createdAt DESC',
    );

    return List.generate(maps.length, (i) {
      return Product.fromMap(maps[i]);
    });
  }

  Future<int> updateProduct(Product product) async {
    final db = await database;
    product.updatedAt = DateTime.now().millisecondsSinceEpoch;
    return await db.update(
      'products',
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  Future<int> desactiveProduct(Product product) async {
    final db = await database;
    product.updatedAt = DateTime.now().millisecondsSinceEpoch;
    product.isActive = false;
    return await db.update(
      'products',
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  Future<Product?> getProductById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'products',
      where: 'id = ? AND isActive = 1',
      whereArgs: [id],
      limit: 1,
    );

    if (maps.isNotEmpty) {
      return Product.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<List<Product>> getLimitedProducts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'products',
      where: 'isActive = 1',
      orderBy: 'createdAt DESC',
      limit: 10,
    );

    return List.generate(maps.length, (i) {
      return Product.fromMap(maps[i]);
    });
  }

  Future<bool> hasUnpaidInvoicesForProduct(int productId) async {
    final db = await database;

    final query = '''
    SELECT COUNT(*) as count
    FROM invoiceLine il
    INNER JOIN invoices i ON il.invoiceId = i.id
    WHERE il.productId = ?
      AND i.type = 'INV_N_P'
      AND (i.totalPayed < i.totalAmount OR i.totalPayed IS NULL OR i.totalPayed = 0)
      AND i.isActive = 1
      AND il.isActive = 1
  ''';

    final result = await db.rawQuery(query, [productId]);
    final count = result.first['count'] as int;

    return count > 0;
  }

  // Categories
  Future<int> insertCategory(Category category) async {
    final db = await database;
    category.isActive = true;
    return await db.insert('categories', category.toMap());
  }

  Future<List<Category>> getCategories() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'categories',
      where: 'isActive = 1',
      orderBy: 'createdAt DESC',
    );

    return List.generate(maps.length, (i) {
      return Category.fromMap(maps[i]);
    });
  }

  Future<int> updateCategory(Category category) async {
    final db = await database;
    return await db.update(
      'categories',
      category.toMap(),
      where: 'id = ?',
      whereArgs: [category.id],
    );
  }

  Future<Category?> getCategoryById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'categories',
      where: 'id = ? AND isActive = 1',
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
  Future<int> insertPaymentMethod(PaymentMethod paymentMethod) async {
    final db = await database;
    paymentMethod.isActive = true;
    return await db.insert('paymentMethods', paymentMethod.toMap());
  }

  Future<List<PaymentMethod>> getPaymentMethods() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'paymentMethods',
      where: 'isActive = 1',
      orderBy: 'createdAt DESC',
    );

    return List.generate(maps.length, (i) {
      return PaymentMethod.fromMap(maps[i]);
    });
  }

  Future<int> updatePaymentMethod(PaymentMethod paymentMethod) async {
    final db = await database;
    return await db.update(
      'paymentMethods',
      paymentMethod.toMap(),
      where: 'id = ?',
      whereArgs: [paymentMethod.id],
    );
  }

  Future<PaymentMethod?> getPaymentMethodById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'paymentMethods',
      where: 'id = ? AND isActive = 1',
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
  Future<int> insertClient(Client client) async {
    final db = await database;
    client.isActive = true;
    return await db.insert('clients', client.toMap());
  }

  Future<List<Client>> getClients() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'clients',
      where: 'isActive = 1',
      orderBy: 'createdAt DESC',
    );

    return List.generate(maps.length, (i) {
      return Client.fromMap(maps[i]);
    });
  }

  Future<int> updateClient(Client client) async {
    final db = await database;
    return await db.update(
      'clients',
      client.toMap(),
      where: 'id = ?',
      whereArgs: [client.id],
    );
  }

  Future<Client?> getClientById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'clients',
      where: 'id = ? AND isActive = 1',
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
  Future<int> insertProvider(Provider provider) async {
    final db = await database;
    provider.isActive = true;
    return await db.insert('providers', provider.toMap());
  }

  Future<List<Provider>> getProviders() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'providers',
      where: 'isActive = 1',
      orderBy: 'createdAt DESC',
    );

    return List.generate(maps.length, (i) {
      return Provider.fromMap(maps[i]);
    });
  }

  Future<int> updateProvider(Provider provider) async {
    final db = await database;
    return await db.update(
      'providers',
      provider.toMap(),
      where: 'id = ?',
      whereArgs: [provider.id],
    );
  }

  Future<Provider?> getProviderById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'providers',
      where: 'id = ? AND isActive = 1',
      whereArgs: [id],
      limit: 1,
    );

    if (maps.isNotEmpty) {
      return Provider.fromMap(maps.first);
    } else {
      return null;
    }
  }

  // Serials
  Future<List<Serial>> getSerialsByProductId(int productId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'serials',
      where: 'productId = ? AND isActive = 1',
      whereArgs: [productId],
    );

    return List.generate(maps.length, (i) {
      return Serial.fromMap(maps[i]);
    });
  }

  Future<int> insertSerial(Serial serial) async {
    final db = await database;
    serial.isActive = true;
    return await db.insert('serials', serial.toMap());
  }

  Future<int> updateSerial(Serial serial) async {
    final db = await database;
    return await db.update(
      'serials',
      serial.toMap(),
      where: 'id = ?',
      whereArgs: [serial.id],
    );
  }

  Future<int> deleteSerial(int id) async {
    final db = await database;
    return await db.update(
      'serials',
      {'isActive': 0, 'updatedAt': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Invoices
  Future<int> insertInvoice(Invoice invoice) async {
    final db = await database;
    invoice.isActive = true;
    return await db.insert('invoices', invoice.toMap());
  }

  Future<List<Invoice>> getInvoices() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'invoices',
      where: 'isActive = 1',
      orderBy: 'createdAt DESC',
    );

    print("invoices = ${maps}");

    return List.generate(maps.length, (i) {
      return Invoice.fromMap(maps[i]);
    });
  }

  Future<int> updateInvoice(Invoice invoice) async {
    final db = await database;
    return await db.update(
      'invoices',
      invoice.toMap(),
      where: 'id = ?',
      whereArgs: [invoice.id],
    );
  }

  Future<Invoice?> getInvoiceById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'invoices',
      where: 'id = ? AND isActive = 1',
      whereArgs: [id],
      limit: 1,
    );

    if (maps.isNotEmpty) {
      return Invoice.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<List<Invoice>> getLimitedInvoices() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'invoices',
      where: 'isActive = 1',
      orderBy: 'createdAt DESC',
      limit: 10,
    );

    // print("invoices: = ${maps}");

    return List.generate(maps.length, (i) {
      return Invoice.fromMap(maps[i]);
    });
  }

  Future<double> getTotalPayed() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT SUM(totalPayed) as total FROM invoices WHERE isActive = 1',
    );
    return result.isNotEmpty ? (result.first['total'] as double? ?? 0.0) : 0.0;
  }

  // InvoiceLine
  Future<List<InvoiceLine>> getInvoiceLinesByInvoiceId(int invoiceId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'invoiceLine',
      where: 'invoiceId = ? AND isActive = 1',
      whereArgs: [invoiceId],
    );

    return List.generate(maps.length, (i) {
      return InvoiceLine.fromMap(maps[i]);
    });
  }

  Future<int> insertInvoiceLine(InvoiceLine invoiceLine) async {
    final db = await database;
    invoiceLine.isActive = true;
    return await db.insert('invoiceLine', invoiceLine.toMap());
  }

  Future<int> deleteInvoiceLine(int id) async {
    final db = await database;
    return await db.update(
      'invoiceLine',
      {'isActive': 0, 'updatedAt': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

// BankAccounts
  Future<int> insertBankAccount(BankAccount bankAccount) async {
    final db = await database;
    bankAccount.isActive = true;
    return await db.insert('banckAccounts', bankAccount.toMap());
  }

  Future<List<BankAccount>> getBankAccounts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'banckAccounts',
      where: 'isActive = 1',
      orderBy: 'createdAt DESC',
    );

    return List.generate(maps.length, (i) {
      return BankAccount.fromMap(maps[i]);
    });
  }

  Future<List<BankAccount>> getBankAccountsByClientId(int clientId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'banckAccounts',
      where: 'clientId = ? AND isActive = 1',
      whereArgs: [clientId],
    );

    return List.generate(maps.length, (i) {
      return BankAccount.fromMap(maps[i]);
    });
  }

  Future<BankAccount?> getBankAccountById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'banckAccounts',
      where: 'id = ? AND isActive = 1',
      whereArgs: [id],
      limit: 1,
    );

    if (maps.isNotEmpty) {
      return BankAccount.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> updateBankAccount(BankAccount bankAccount) async {
    final db = await database;
    return await db.update(
      'banckAccounts',
      bankAccount.toMap(),
      where: 'id = ?',
      whereArgs: [bankAccount.id],
    );
  }

  Future<int> deleteBankAccount(int id) async {
    final db = await database;
    return await db.update(
      'banckAccounts',
      {'isActive': 0, 'updatedAt': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Users
  Future<int> insertUser(User user) async {
    final db = await database;
    user.isActive = true;
    return await db.insert('users', user.toMap());
  }

  Future<List<User>> getUsers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'isActive = 1',
      orderBy: 'createdAt DESC',
    );

    return List.generate(maps.length, (i) {
      return User.fromMap(maps[i]);
    });
  }

  Future<int> updateUser(User user) async {
    final db = await database;
    return await db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<User?> getUserById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'id = ? AND isActive = 1',
      whereArgs: [id],
      limit: 1,
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    } else {
      return null;
    }
  }

  //Reports
  Future<List<Map<String, dynamic>>> getSalesReport(
      int startDate, int endDate) async {
    final db = await database;

    final query = '''
    SELECT 
      i.id AS invoiceId,
      i.documentNo,
      i.createdAt AS invoiceDate,
      il.productName,
      il.productPrice,
      il.qty,
      il.productSerial,
      il.total AS lineTotal
    FROM invoices i
    INNER JOIN invoiceLine il ON i.id = il.invoiceId
    WHERE i.createdAt >= ? AND i.createdAt <= ?
    ORDER BY i.createdAt ASC
  ''';

    final result = await db.rawQuery(query, [startDate, endDate]);
    result.forEach((row) => print(row));

    return result;
  }
}
