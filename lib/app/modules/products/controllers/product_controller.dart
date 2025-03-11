import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teck_app/app/database/database_helper.dart';
import 'package:teck_app/app/database/models/products_model.dart';

import '../../../../theme/colors.dart';
import '../../../common/custom_snakcbar.dart';
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
  // Controladores de texto
  final nameController = TextEditingController();
  final codeController = TextEditingController();
  final priceController = TextEditingController();
  final minStockController = TextEditingController();
  final newSerialController = TextEditingController();
  final qtyController = TextEditingController();
  final RxInt serialsQty = 0.obs;
  final RxInt providerId = 0.obs;
  final RxInt categoryId = 0.obs;
  final RxBool isSerial = false.obs;

  final RxString editingProductId = ''.obs;

  final RxBool hasSerials = false.obs;

  final dbHelper = DatabaseHelper();

  @override
  void onInit() {
    super.onInit();
    fetchAllProducts();
  }

  @override
  void onClose() {
    nameController.dispose();
    codeController.dispose();
    priceController.dispose();
    minStockController.dispose();
    qtyController.dispose();
    newSerialController.dispose();
    super.onClose();
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

    final product = Product(
      id: editingProductId.value.isEmpty
          ? null
          : int.parse(editingProductId.value),
      name: nameController.text,
      code: codeController.text,
      price: double.tryParse(priceController.text) ?? 0.0,
      serialsQty: isSerial.value
          ? serials.length
          : int.tryParse(qtyController.text) ?? 0,
      minStock: int.tryParse(minStockController.text) ?? 0,
      categoryId: selectedCategory.value!.id!,
      providerId: selectedProvider.value!.id!,
      createdAt: DateTime.now(),
      isActive: true,
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
        Get.back();
        CustomSnackbar.show(
          title: "¡Aprobado!",
          message: "Producto guardado correctamente",
          icon: Icons.check_circle,
          backgroundColor: AppColors.principalGreen,
        );
      } else {
        await dbHelper.updateProduct(product);
        Get.back();
        CustomSnackbar.show(
          title: "¡Aprobado!",
          message: "Producto editado correctamente",
          icon: Icons.check_circle,
          backgroundColor: AppColors.principalGreen,
        );
      }
      fetchAllProducts();
      clearFields();
      editingProductId.value = '';
    } catch (e) {
      CustomSnackbar.show(
        title: "¡Ocurrió un error!",
        message: "Verifique los datos e intente nuevamente.",
        icon: Icons.cancel,
        backgroundColor: AppColors.invalid,
      );
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
    nameController.dispose();
    codeController.dispose();
    priceController.dispose();
    minStockController.dispose();
    qtyController.dispose();
    newSerialController.dispose();
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
          product.name
              .toLowerCase()
              .contains(searchQuery.value.toLowerCase()) ||
          (product.code
                  ?.toLowerCase()
                  .contains(searchQuery.value.toLowerCase()) ??
              false);

      final matchesProvider = selectedProviderId.value == 0 ||
          product.providerId == selectedProviderId.value;

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
    editingProductId.value = product.id.toString();
    nameController.text = product.name;
    codeController.text = product.code ?? '';
    priceController.text = product.price.toString();
    minStockController.text = product.minStock.toString();
    qtyController.text = product.serialsQty.toString();

    selectCategory(categories.firstWhereOrNull((c) => c.id == product.categoryId));
    selectProvider(providers.firstWhereOrNull((p) => p.id == product.providerId));

    final serialsList = await dbHelper.getSerialsByProductId(product.id!);
    hasSerials.value = serialsList.isNotEmpty;
    if (hasSerials.value) {
      serials.assignAll(serialsList.map((s) => s.serial));
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
