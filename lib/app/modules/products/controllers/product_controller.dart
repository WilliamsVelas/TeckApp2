import 'package:get/get.dart';
import 'package:teck_app/app/database/database_helper.dart';
import 'package:teck_app/app/database/models/products_model.dart';

class ProductController extends GetxController {
  final RxList<Product> products = <Product>[].obs;
  final RxList<Product> filteredProducts = <Product>[].obs;
  final RxString searchQuery = ''.obs;
  final RxString selectedStatus = ''.obs;
  final RxInt selectedProviderId = 0.obs;
  final RxString sortCriteria = ''.obs;

  //Product
  final RxString name = 'Q3'.obs;
  final RxString code = '00021'.obs;
  final RxDouble price = 130.0.obs;
  final RxInt minStock = 10.obs;
  final RxInt providerId = 1.obs;
  final RxString status = 'Activo'.obs;

  final dbHelper = DatabaseHelper();

  @override
  void onInit() {
    super.onInit();
    fetchAllProducts();
  }

  Future<void> saveProduct() async {
    final product = Product(
      name: 'OTRO',
      code: '0021',
      price: 130.0,
      refPrice: 332.10,
      status: 'activo',
      minStock: 9,
      serialsQty: 2,
      categoryId: 1,
      providerId: 1,
      createdAt: DateTime.now(),
    );

    try {
      await dbHelper.insertProduct(product);
      fetchAllProducts();
      clearFields();
    } catch (e) {
      print('Error al guardar el producto: $e');
    }
  }

  void clearFields() {
    name.value = '';
    code.value = '';
    price.value = 0.0;
    minStock.value = 0;
    providerId.value = 0;
    status.value = '';
  }

  void fetchAllProducts() async {
    final List<Product> allProducts = await dbHelper.getProducts();
    products.assignAll(allProducts);
    filteredProducts.assignAll(allProducts);
  }

  void searchProducts(String query) {
    searchQuery.value = query;
    applyFilters();
  }

  void filterByStatus(String status) {
    selectedStatus.value = status;
    applyFilters();
  }

  void filterByProvider(int providerId) {
    selectedProviderId.value = providerId;
    applyFilters();
  }

  void sortProducts(String criteria) {
    sortCriteria.value = criteria;
    applyFilters();
  }

  void applyFilters() {
    var tempProducts = products.where((product) {
      final matchesSearch = searchQuery.isEmpty ||
          product.name.contains(searchQuery.value) ||
          product.code!.contains(searchQuery.value);
      final matchesStatus =
          selectedStatus.isEmpty || product.status == selectedStatus.value;
      final matchesProvider = selectedProviderId.value == 0 ||
          product.providerId == selectedProviderId.value;
      return matchesSearch && matchesStatus && matchesProvider;
    }).toList();

    if (sortCriteria.value == 'date') {
      tempProducts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } else if (sortCriteria.value == 'price') {
      tempProducts.sort((a, b) => a.price.compareTo(b.price));
    } else if (sortCriteria.value == 'stock') {
      tempProducts.sort((a, b) => a.minStock.compareTo(b.minStock));
    }
    filteredProducts.assignAll(tempProducts);
  }
}
