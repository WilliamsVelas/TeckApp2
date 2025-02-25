import 'package:get/get.dart';

import '../../../database/database_helper.dart';
import '../../../database/models/categories_model.dart';

class CategoriesController extends GetxController {
  final RxList<Category> categories = <Category>[].obs;
  final RxString searchQuery = ''.obs;
  final RxString sortCriteria = ''.obs;
  final RxBool showInactive = false.obs; // Nuevo: Mostrar categorías desactivadas

  final RxList<Category> originalCategories = <Category>[].obs;

  // Category
  final RxString name = ''.obs;
  final RxString? code = ''.obs;

  final dbHelper = DatabaseHelper();

  @override
  void onInit() {
    super.onInit();
    fetchAllCategories();
  }

  Future<void> saveCategory() async {
    final category = Category(
      name: name.value,
      code: code?.value,
      createdAt: DateTime.now(),
    );

    try {
      await dbHelper.insertCategory(category);
      fetchAllCategories();
      clearFields();
    } catch (e) {
      print('Error al guardar la categoría: $e');
    }
  }

  Future<void> deactivateCategory(int categoryId) async {
    try {
      final category = await dbHelper.getCategoryById(categoryId);
      if (category != null) {
        category.isActive = false;
        category.updatedAt = DateTime.now();
        await dbHelper.updateCategory(category);
        fetchAllCategories(); // Recargar categorías después de desactivar
        print('Categoría desactivada con ID: $categoryId');
      } else {
        print('Categoría con ID $categoryId no encontrada');
      }
    } catch (e) {
      print('Error al desactivar la categoría: $e');
    }
  }

  void clearFields() {
    name.value = '';
    code?.value = '';
  }

  Future<void> fetchAllCategories() async {
    final List<Category> allCategories = await dbHelper.getCategories();
    categories.assignAll(allCategories.where((cat) => cat.isActive)); // Solo activas por defecto
    originalCategories.assignAll(allCategories); // Todas, incluidas inactivas
    applyFilters();
  }

  void toggleShowInactive(bool value) {
    showInactive.value = value;
    applyFilters();
  }

  void searchCategories(String query) {
    searchQuery.value = query;
    applyFilters();
  }

  void sortCategories(String criteria) {
    sortCriteria.value = criteria;
    applyFilters();
  }

  void applyFilters() {
    var filtered = originalCategories.where((category) {
      final matchesSearch = searchQuery.isEmpty ||
          category.name.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          (category.code?.toLowerCase().contains(searchQuery.value.toLowerCase()) ?? false);

      // Filtrar por estado activo/inactivo según showInactive
      final matchesStatus = showInactive.value || category.isActive;

      return matchesSearch && matchesStatus;
    }).toList();

    if (sortCriteria.value == 'date') {
      filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } else if (sortCriteria.value == 'name') {
      filtered.sort((a, b) => a.name.compareTo(b.name));
    }

    categories.value = filtered;
  }
}