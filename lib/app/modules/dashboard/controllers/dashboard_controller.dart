import 'package:get/get.dart';

import '../../../database/database_helper.dart';
import '../../../database/models/invoices_model.dart';
import '../../../database/models/products_model.dart';

class DashboardController extends GetxController {
  final RxList<Product> products = <Product>[].obs;
  final RxList<Invoice> invoices = <Invoice>[].obs;
  final RxInt totalSales = 0.obs;
  final RxDouble totalPayed = 0.0.obs;

  final dbHelper = DatabaseHelper();

  @override
  void onInit() {
    super.onInit();
    fetchAll();
  }

  void fetchAll() {
    fetchAllProducts();
    fetchAllInvoices();
    fetchTotalPayed();
    fetchTotalSales();
  }

  Future<void> fetchAllProducts() async {
    final List<Product> allProducts = await dbHelper.getLimitedProducts();
    products.assignAll(allProducts.where((prod) => prod.isActive));
  }

  Future<void> fetchAllInvoices() async {
    final List<Invoice> allInvoices = await dbHelper.getLimitedInvoices();
    invoices.assignAll(allInvoices);
  }

  Future<void> fetchTotalSales() async {
    final List<Invoice> allInvoices = await dbHelper.getInvoices();
    totalSales.value = allInvoices.length;
  }

  Future<void> fetchTotalPayed() async {
    totalPayed.value = await dbHelper.getTotalPayed();
  }
}
