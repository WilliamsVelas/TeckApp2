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
import '../views/product_view.dart';

class ProductController extends GetxController {
  final RxList<Product> products = <Product>[].obs;
  final RxString searchQuery = ''.obs;
  final RxString selectedStatus = ''.obs;
  final RxInt selectedProviderId = 0.obs;
  final RxInt selectedCategoryId = 0.obs;
  final RxString sortCriteria = ''.obs;
  final RxBool showInactive = false.obs;

  final RxList<Product> originalProducts = <Product>[].obs;

  final RxList<String> serials = <String>[].obs;
  final RxString newSerial = ''.obs;

  final RxList<Category> categories = <Category>[].obs;
  final RxList<Provider> providers = <Provider>[].obs;

  final RxList<Serial> productSerials = <Serial>[].obs;
  final RxBool isLoadingSerials = false.obs;

  final Rx<Category?> selectedCategory = Rx<Category?>(null);
  final Rx<Provider?> selectedProvider = Rx<Provider?>(null);

  final RxString name = ''.obs;
  final RxString code = ''.obs;
  final RxString price = ''.obs;
  final RxString minStock = ''.obs;

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

  final RxBool isLoadingCategories = false.obs;
  final RxBool isLoadingProviders = false.obs;

  final dbHelper = DatabaseHelper();

  @override
  void onInit() {
    super.onInit();
    fetchAllProducts();
    fetchAllCategories();
  }

  @override
  void onClose() {
    nameController.clear();
    codeController.clear();
    priceController.clear();
    minStockController.clear();
    qtyController.clear();
    newSerialController.clear();
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
    isLoadingCategories.value = true;
    try {
      final List<Category> allCategories = await dbHelper.getCategories();
      categories.assignAll(allCategories);
    } catch (e) {
      print('Error cargando categorías: $e');
    } finally {
      isLoadingCategories.value = false;
    }
  }

  Future<void> fetchAllProviders() async {
    isLoadingProviders.value = true;
    try {
      final List<Provider> allProviders = await dbHelper.getProviders();
      providers.assignAll(allProviders);
    } catch (e) {
      print('Error cargando proveedores: $e');
    } finally {
      isLoadingProviders.value = false;
    }
  }

  Future<bool> hasCategoriesAndProviders() async {
    if (categories.isEmpty) {
      await fetchAllCategories();
    }
    if (providers.isEmpty) {
      await fetchAllProviders();
    }
    return categories.isNotEmpty && providers.isNotEmpty;
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
    if (nameController.text.trim().isEmpty ||
        codeController.text.trim().isEmpty) {
      CustomSnackbar.show(
        title: "¡Ocurrió un error!",
        message: "El nombre y el código del producto no pueden estar vacíos.",
        icon: Icons.cancel,
        backgroundColor: AppColors.invalid,
      );
      return;
    }

    double? price = double.tryParse(priceController.text);
    if (price == null || price < 0 || !_hasTwoOrFewerDecimals(price)) {
      CustomSnackbar.show(
        title: "¡Ocurrió un error!",
        message:
            "El precio debe ser un número válido, positivo y con máximo dos decimales.",
        icon: Icons.cancel,
        backgroundColor: AppColors.invalid,
      );
      return;
    }

    int? serialsQty =
        isSerial.value ? serials.length : int.tryParse(qtyController.text);
    if (serialsQty == null || serialsQty < 0) {
      CustomSnackbar.show(
        title: "¡Ocurrió un error!",
        message: "La cantidad debe ser un número entero positivo.",
        icon: Icons.cancel,
        backgroundColor: AppColors.invalid,
      );
      return;
    }

    int? minStock = int.tryParse(minStockController.text);
    if (minStock == null || minStock < 0) {
      CustomSnackbar.show(
        title: "¡Ocurrió un error!",
        message: "El stock mínimo debe ser un número entero positivo.",
        icon: Icons.cancel,
        backgroundColor: AppColors.invalid,
      );
      return;
    }

    if (selectedCategory.value == null || selectedProvider.value == null) {
      CustomSnackbar.show(
        title: "¡Ocurrió un error!",
        message: "Debe seleccionar una categoría y un proveedor.",
        icon: Icons.cancel,
        backgroundColor: AppColors.invalid,
      );
      return;
    }

    final product = Product(
      id: editingProductId.value.isEmpty
          ? null
          : int.parse(editingProductId.value),
      name: nameController.text.trim(),
      code: codeController.text.trim(),
      price: price,
      serialsQty: serialsQty,
      minStock: minStock,
      categoryId: selectedCategory.value!.id!,
      providerId: selectedProvider.value!.id!,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      isActive: true,
    );

    try {
      if (editingProductId.value.isEmpty) {
        int productId = await dbHelper.insertProduct(product);

        if (isSerial.value) {
          for (var serialNumber in serials) {
            Serial serial = Serial(
              productId: productId,
              status: "activo",
              serial: serialNumber,
              createdAt: DateTime.now().millisecondsSinceEpoch,
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

  bool _hasTwoOrFewerDecimals(double number) {
    return (number * 100).roundToDouble() == number * 100;
  }

  Future<bool> canDeactivateProduct(int productId) async {
    return await dbHelper.hasUnpaidInvoicesForProduct(productId);
  }

  Future<void> deactivateProduct(int productId) async {
    try {
      final hasUnpaid = await canDeactivateProduct(productId);
      if (hasUnpaid) {
        CustomSnackbar.show(
          title: "¡Acción no permitida!",
          message: "No puedes desactivar un producto con ventas impagas.",
          icon: Icons.cancel,
          backgroundColor: AppColors.invalid,
        );
        return;
      }

      final product = await dbHelper.getProductById(productId);
      if (product != null) {
        product.isActive = false;
        product.updatedAt = DateTime.now().millisecondsSinceEpoch;
        await dbHelper.updateProduct(product);
        fetchAllProducts();
        CustomSnackbar.show(
          title: "¡Aprobado!",
          message: "Producto borrado correctamente",
          icon: Icons.check_circle,
          backgroundColor: AppColors.principalGreen,
        );
      } else {
        print('Producto con ID $productId no encontrado');
      }
    } catch (e) {
      print('Error al desactivar el producto: $e');
    }
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
    if (status == 'Inactivo') {
      showInactive.value = true;
    } else if (status == 'Activo') {
      showInactive.value = false;
    }
    applyFilters();
  }

  void filterByProvider(int? providerId) {
    selectedProviderId.value = providerId ?? 0;
    applyFilters();
  }

  void filterByCategory(int? categoryId) {
    selectedCategoryId.value = categoryId ?? 0;
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

      // final matchesProvider = selectedProviderId.value == 0 ||
      //     product.providerId == selectedProviderId.value;

      final matchesCategory = selectedCategoryId.value == 0 ||
          product.categoryId == selectedCategoryId.value;

      final matchesStatus = selectedStatus.value.isEmpty ||
          (selectedStatus.value == 'Activo' && product.isActive) ||
          (selectedStatus.value == 'Inactivo' && !product.isActive);

      return matchesSearch && matchesStatus && matchesCategory;
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

    selectCategory(
        categories.firstWhereOrNull((c) => c.id == product.categoryId));
    selectProvider(
        providers.firstWhereOrNull((p) => p.id == product.providerId));

    final serialsList = await dbHelper.getSerialsByProductId(product.id!);
    hasSerials.value = serialsList.isNotEmpty;

    if (hasSerials.value) {
      isSerial.value = true;
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

  void clearFields() {
    nameController.clear();
    codeController.clear();
    priceController.clear();
    minStockController.clear();
    qtyController.clear();
    newSerialController.clear();
    providerId.value = 0;
    categoryId.value = 0;
    newSerial.value = '';
    selectedCategory.value = null;
    selectedProvider.value = null;
    newSerialController.clear();
    qtyController.clear();
    isSerial.value = false;
    editingProductId.value = '';
    hasSerials.value = false;
  }

  void clearLists() {
    serials.clear();
    categories.clear();
    providers.clear();
  }
}