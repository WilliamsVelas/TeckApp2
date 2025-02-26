import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:teck_app/app/database/database_helper.dart';
import 'package:teck_app/app/database/models/products_model.dart';

import '../../../database/models/categories_model.dart';
import '../../../database/models/providers_model.dart';
import '../../../database/models/serials_model.dart';

class ProductController extends GetxController {
  final RxList<Product> products = <Product>[].obs;
  final RxString searchQuery = ''.obs;
  final RxString selectedStatus = ''.obs;
  final RxInt selectedProviderId = 0.obs;
  final RxString sortCriteria = ''.obs;
  final RxBool showInactive = false.obs;

  final RxList<Product> originalProducts = <Product>[].obs;

  final RxList<String> serials = <String>[].obs;
  final RxString newSerial = ''.obs;

  final RxList<Category> categories = <Category>[].obs;
  final RxList<Provider> providers = <Provider>[].obs;

  // Selected Values
  final Rx<Category?> selectedCategory = Rx<Category?>(null);
  final Rx<Provider?> selectedProvider = Rx<Provider?>(null);

  // Product
  final RxString name = ''.obs;
  final RxString code = ''.obs;
  final RxString price = ''.obs;
  final RxString minStock = ''.obs;
  final RxInt serialsQty = 0.obs;
  final RxInt providerId = 0.obs;
  final RxInt categoryId = 0.obs;
  final RxBool isSerial = false.obs; // Nuevo flag para controlar seriales

  final dbHelper = DatabaseHelper();

  final newSerialController = TextEditingController();
  final qtyController = TextEditingController(); // controlador para qty

  @override
  void onInit() {
    super.onInit();
    fetchAllProducts();
  }

  void fetchAll() {
    fetchAllCategories();
    fetchAllProviders();
  }

  Future<String> getCategoryName(int categoryId) async {
    Category? category = await dbHelper.getCategoryById(categoryId);
    return category?.name ?? 'N/A';
  }

  Future<String> getProviderName(int providerId) async {
    Provider? provider = await dbHelper.getProviderById(providerId);
    return provider?.name ?? 'N/A';
  }

  Future<void> fetchAllCategories() async {
    final List<Category> allCategories = await dbHelper.getCategories();
    categories.assignAll(allCategories);
  }

  Future<void> fetchAllProviders() async {
    final List<Provider> allProviders = await dbHelper.getProviders();
    providers.assignAll(allProviders);
  }

  void selectCategory(Category? category) {
    selectedCategory.value = category;
    categoryId.value = category?.id ?? 0;
  }

  void selectProvider(Provider? provider) {
    selectedProvider.value = provider;
    providerId.value = provider?.id ?? 0;
  }

  void addSerial() {
    if (newSerial.value.isNotEmpty) {
      serials.add(newSerial.value);
      newSerialController.clear();
      newSerial.value = '';
    }
  }

  void removeSerial(int index) {
    serials.removeAt(index);
  }

  Future<void> saveProduct() async {
    if (selectedCategory.value == null) {
      print('Categoría no seleccionada');
      return;
    }
    if (selectedProvider.value == null) {
      print('Proveedor no seleccionado');
      return;
    }
    double parsedPrice = 0.0;
    try {
      parsedPrice = double.parse(price.value);
    } catch (e) {
      print('Error al convertir el precio: $e');
      return;
    }

    int parsedMinStock = 0;
    try {
      parsedMinStock = int.parse(minStock.value);
    } catch (e) {
      print('Error al convertir el stock mínimo: $e');
      return;
    }

    int parsedQty = 0;
    if (isSerial.value) {
      parsedQty = serials.length; // Cantidad de seriales
    } else {
      try {
        parsedQty = int.parse(qtyController.text); // Cantidad directa
      } catch (e) {
        print('Error al convertir la cantidad: $e');
        return;
      }
    }

    final product = Product(
      name: name.value,
      code: code.value,
      price: parsedPrice,
      serialsQty: parsedQty, // Usamos parsedQty según isSerial
      refPrice: parsedPrice,
      minStock: parsedMinStock,
      categoryId: selectedCategory.value!.id!,
      providerId: selectedProvider.value!.id!,
      createdAt: DateTime.now(),
    );

    try {
      int productId = await dbHelper.insertProduct(product);
      print('Producto guardado con ID: $productId');

      if (isSerial.value) {
        for (var serialNumber in serials) {
          Serial serial = Serial(
            productId: productId,
            serial: serialNumber,
            createdAt: DateTime.now(),
          );
          await dbHelper.insertSerial(serial);
        }
        print('Seriales guardados para el producto $productId');
      }

      fetchAllProducts();
      Get.back();
    } catch (e) {
      print('Error al guardar el producto y/o los seriales: $e');
    }
  }

  Future<void> deactivateProduct(int productId) async {
    try {
      final product = await dbHelper.getProductById(productId);
      if (product != null) {
        product.isActive = false;
        product.updatedAt = DateTime.now();
        await dbHelper.updateProduct(product);
        fetchAllProducts();
        print('Producto desactivado con ID: $productId');
      } else {
        print('Producto con ID $productId no encontrado');
      }
    } catch (e) {
      print('Error al desactivar el producto: $e');
    }
  }

  void clearFields() {
    name.value = '';
    code.value = '';
    price.value = '';
    minStock.value = '';
    providerId.value = 0;
    categoryId.value = 0;
    serials.clear();
    categories.clear();
    providers.clear();
    newSerial.value = '';
    selectedCategory.value = null;
    selectedProvider.value = null;
    newSerialController.clear();
    qtyController.clear(); // Limpiar qtyController
    isSerial.value = false; // Reiniciar isSerial
  }

  void toggleShowInactive(bool value) {
    showInactive.value = value;
    applyFilters();
  }

  Future<void> fetchAllProducts() async {
    final List<Product> allProducts = await dbHelper.getProducts();
    products.assignAll(allProducts.where((prod) => prod.isActive));
    originalProducts.assignAll(allProducts);
    applyFilters();
  }

  void searchProducts(String query) {
    searchQuery.value = query;
    applyFilters();
  }

  void filterByStatus(String? status) {
    selectedStatus.value = status ?? '';
    applyFilters();
  }

  void filterByProvider(int? providerId) {
    selectedProviderId.value = providerId ?? 0;
    applyFilters();
  }

  void sortProducts(String criteria) {
    sortCriteria.value = criteria;
    applyFilters();
  }

  void applyFilters() {
    final filtered = originalProducts.where((product) {
      final matchesSearch = searchQuery.isEmpty ||
          product.name.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          (product.code?.toLowerCase().contains(searchQuery.value.toLowerCase()) ?? false);

      final matchesProvider = selectedProviderId.value == 0 || product.providerId == selectedProviderId.value;

      final matchesStatus = showInactive.value || product.isActive;

      return matchesSearch && matchesProvider && matchesStatus;
    }).toList();

    if (sortCriteria.value == 'date') {
      filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } else if (sortCriteria.value == 'price') {
      filtered.sort((a, b) => a.price.compareTo(b.price));
    } else if (sortCriteria.value == 'stock') {
      filtered.sort((a, b) => a.minStock.compareTo(b.minStock));
    }

    products.value = filtered;
  }
}