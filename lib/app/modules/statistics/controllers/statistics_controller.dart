import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../../database/database_helper.dart';

class StatisticsController extends GetxController {
  final DatabaseHelper dbHelper = DatabaseHelper();
  final RxList<Map<String, dynamic>> topSoldProducts = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> nearMinStockProducts = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> salesByDate = <Map<String, dynamic>>[].obs;
  final RxBool isLoading = true.obs;

  final Rx<DateTime?> startDate = Rx<DateTime?>(null);
  final Rx<DateTime?> endDate = Rx<DateTime?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchStatistics();
  }

  Future<void> fetchStatistics({DateTime? start, DateTime? end}) async {
    isLoading.value = true;
    final db = await dbHelper.database;

    final int? startTimestamp = start?.millisecondsSinceEpoch;
    final int? endTimestamp = end?.millisecondsSinceEpoch;

    // Consulta para productos más vendidos
    String topSoldQuery = '''
      SELECT p.id, p.name, COUNT(il.id) as total_sold
      FROM products p
      JOIN invoiceLine il ON p.id = il.productId
      JOIN invoices i ON i.id = il.invoiceId
      WHERE p.isActive = 1 AND i.isActive = 1 AND il.isActive = 1
    ''';
    List<dynamic> topSoldParams = [];
    if (startTimestamp != null && endTimestamp != null) {
      topSoldQuery += ' AND i.createdAt >= ? AND i.createdAt <= ?';
      topSoldParams.addAll([startTimestamp, endTimestamp]);
    }
    topSoldQuery += ' GROUP BY p.id, p.name ORDER BY total_sold DESC LIMIT 5';
    final topSoldResult = await db.rawQuery(topSoldQuery, topSoldParams);
    topSoldProducts.assignAll(topSoldResult);

    // Consulta para productos cerca del stock mínimo
    final nearMinStockResult = await db.rawQuery('''
      SELECT id, name, serialsQty, minStock
      FROM products
      WHERE isActive = 1 AND serialsQty <= minStock * 1.5
      ORDER BY (minStock - serialsQty) DESC
      LIMIT 5
    ''');
    nearMinStockProducts.assignAll(nearMinStockResult);

    // Consulta para ventas por fecha (corregida)
    String salesByDateQuery = '''
      SELECT DATE(DATETIME(i.createdAt / 1000, 'unixepoch')) as sale_date, SUM(i.totalAmount) as total_sales
      FROM invoices i
      WHERE i.isActive = 1
    ''';
    List<dynamic> salesByDateParams = [];
    if (startTimestamp != null && endTimestamp != null) {
      salesByDateQuery += ' AND i.createdAt >= ? AND i.createdAt <= ?';
      salesByDateParams.addAll([startTimestamp, endTimestamp]);
    }
    // Escapamos las comillas internas o usamos una cadena continua
    salesByDateQuery += " GROUP BY DATE(DATETIME(i.createdAt / 1000, 'unixepoch')) ORDER BY sale_date ASC";
    final salesByDateResult = await db.rawQuery(salesByDateQuery, salesByDateParams);
    print('salesByDateResult: $salesByDateResult'); // Para verificar
    salesByDate.assignAll(salesByDateResult);

    isLoading.value = false;
  }

  void updateStatistics() {
    fetchStatistics(start: startDate.value, end: endDate.value);
  }
}