import 'package:get/get.dart';

import '../../../database/database_helper.dart';
import '../../../database/models/categories_model.dart';

class CategoriesController extends GetxController{
  final RxList<Category> categories = <Category>[].obs;
  final RxString searchQuery = ''.obs;
  final RxString sortCriteria = ''.obs;

  final RxList<Category> originalCategories = <Category>[].obs;

  //Category
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
      print('Error al guardar la categoria: $e');
    }
  }

  void clearFields() {
    name.value = '';
    code?.value = '';
  }

  void fetchAllCategories() async {
    final List<Category> allCategories = await dbHelper.getCategories();
    categories.assignAll(allCategories);
    originalCategories.assignAll(allCategories);
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
    final filtered = originalCategories.where((category) {
      final matchesSearch = searchQuery.isEmpty ||
          category.name.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          (category.code?.toLowerCase().contains(searchQuery.value.toLowerCase()) ?? false);

      return matchesSearch;
    }).toList();

    if (sortCriteria.value == 'date') {
      filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } else if (sortCriteria.value == 'name') {
      filtered.sort((a, b) => a.name.compareTo(b.name));
    }

    categories.value = filtered;
  }
}