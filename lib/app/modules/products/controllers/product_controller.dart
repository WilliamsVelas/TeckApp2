import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teck_app/app/database/database_helper.dart';
import 'package:teck_app/app/database/models/products_model.dart';

import '../../../../theme/colors.dart';
import '../../../database/models/categories_model.dart';
import '../../../database/models/providers_model.dart';
import '../../../database/models/serials_model.dart';
import '../views/product_card.dart';
import '../views/product_form.dart';
import '../views/product_view.dart';

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

  //Serials
  final RxList<Serial> productSerials = <Serial>[].obs;
  final RxBool isLoadingSerials = false.obs;

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
  final RxBool isSerial = false.obs;

  final RxString editingProductId = ''.obs;

  final RxBool hasSerials = false.obs;

  final dbHelper = DatabaseHelper();

  final newSerialController = TextEditingController();
  final qtyController = TextEditingController();

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
    if (editingProductId.value.isEmpty) {

      if (isSerial.value) {
        parsedQty = serials.length;
      } else {
        try {
          parsedQty = int.parse(qtyController.text);
        } catch (e) {
          print('Error al convertir la cantidad: $e');
          return;
        }
      }
    } else {

      final productId = int.tryParse(editingProductId.value);
      final product = products.firstWhere((p) => p.id == productId);
      if (hasSerials.value) {
        parsedQty = product.serialsQty;
      } else {
        try {
          parsedQty = int.parse(qtyController.text);
        } catch (e) {
          print('Error al convertir la cantidad: $e');
          return;
        }
      }
    }

    final product = Product(
      id: editingProductId.value.isNotEmpty ? int.tryParse(editingProductId.value) : null,
      name: name.value,
      code: code.value,
      price: parsedPrice,
      serialsQty: parsedQty,
      refPrice: parsedPrice,
      minStock: parsedMinStock,
      categoryId: selectedCategory.value!.id!,
      providerId: selectedProvider.value!.id!,
      createdAt: editingProductId.value.isEmpty
          ? DateTime.now()
          : products.firstWhere((p) => p.id == int.tryParse(editingProductId.value)).createdAt,
      updatedAt: editingProductId.value.isNotEmpty ? DateTime.now() : null,
      isActive: editingProductId.value.isEmpty
          ? true
          : products.firstWhere((p) => p.id == int.tryParse(editingProductId.value)).isActive,
    );

    try {
      if (editingProductId.value.isEmpty) {
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
      } else {
        // Edición
        await dbHelper.updateProduct(product);
        print('Producto actualizado con ID: ${product.id}');
      }
      fetchAllProducts();
      clearFields();
      editingProductId.value = '';
      Get.back();
    } catch (e) {
      print('Error al guardar/actualizar el producto: $e');
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
    qtyController.clear();
    isSerial.value = false;
    editingProductId.value = '';
    hasSerials.value = false;
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

  Future<void> editProduct(Product product) async {
    if (categories.isEmpty) {
      await fetchAllCategories();
    }
    if (providers.isEmpty) {
      await fetchAllProviders();
    }

    editingProductId.value = product.id.toString();
    name.value = product.name;
    code.value = product.code ?? '';
    price.value = product.price.toString();
    minStock.value = product.minStock.toString();
    serialsQty.value = product.serialsQty;

    try {
      final category = categories.firstWhere((cat) => cat.id == product.categoryId);
      selectCategory(category);
    } catch (e) {
      print('Categoría no encontrada para el producto: ${product.categoryId}');
      selectCategory(null);
    }

    try {
      final provider = providers.firstWhere((prov) => prov.id == product.providerId);
      selectProvider(provider);
    } catch (e) {
      print('Proveedor no encontrado para el producto: ${product.providerId}');
      selectProvider(null);
    }

    final serialsList = await dbHelper.getSerialsByProductId(product.id!);
    hasSerials.value = serialsList.isNotEmpty;

    if (!hasSerials.value) {
      qtyController.text = product.serialsQty.toString();
    } else {
      qtyController.text = serialsList.length.toString();
    }
    Get.to(() => ProductFormView());
  }

  Future<void> loadProductSerials(int productId) async {
    try {
      isLoadingSerials.value = true;
      final serials = await dbHelper.getSerialsByProductId(productId);
      productSerials.assignAll(serials);
    } catch (e) {
      print('Error cargando seriales: $e');
    } finally {
      isLoadingSerials.value = false;
    }
  }

  void showSerialsProductModal(int productId, BuildContext context) {
    loadProductSerials(productId);
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.principalBackground,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            top: 8.0,
            left: 16.0,
            right: 16.0,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SerialsModal(productId: productId),
        );
      },
    );
  }
}