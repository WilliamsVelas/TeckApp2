import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../../database/database_helper.dart';

class StatisticsController extends GetxController {
  final DatabaseHelper dbHelper = DatabaseHelper();
  final RxList<Map<String, dynamic>> topSoldProducts = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> nearMinStockProducts = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> salesByDate = <Map<String, dynamic>>[].obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchStatistics();
  }

  Future<void> fetchStatistics() async {
    isLoading.value = true;
    final db = await dbHelper.database;

    // Productos más vendidos (corregir invoice_lines a invoiceLine)
    final topSoldResult = await db.rawQuery('''
      SELECT p.id, p.name, COUNT(il.id) as total_sold
      FROM products p
      JOIN invoiceLine il ON p.id = il.productId
      JOIN invoices i ON i.id = il.invoiceId
      WHERE p.isActive = 1 AND i.isActive = 1 AND il.isActive = 1
      GROUP BY p.id, p.name
      ORDER BY total_sold DESC
      LIMIT 5
    ''');
    topSoldProducts.assignAll(topSoldResult);

    // Productos cercanos al stock mínimo
    final nearMinStockResult = await db.rawQuery('''
      SELECT id, name, serialsQty, minStock
      FROM products
      WHERE isActive = 1 AND serialsQty <= minStock * 1.5
      ORDER BY (minStock - serialsQty) DESC
      LIMIT 5
    ''');
    nearMinStockProducts.assignAll(nearMinStockResult);

    // Ventas por fecha
    final salesByDateResult = await db.rawQuery('''
      SELECT DATE(i.createdAt) as sale_date, SUM(i.totalAmount) as total_sales
      FROM invoices i
      WHERE i.isActive = 1
      GROUP BY DATE(i.createdAt)
      ORDER BY sale_date ASC
    ''');
    salesByDate.assignAll(salesByDateResult);

    isLoading.value = false;
  }
}
