import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../theme/colors.dart';
import '../../../common/custom_snakcbar.dart';
import '../../../database/database_helper.dart';
import '../../../database/models/categories_model.dart';
import '../widgets/categories_form.dart';

class CategoriesController extends GetxController {
  final RxList<Category> categories = <Category>[].obs;
  final RxString searchQuery = ''.obs;
  final RxString sortCriteria = ''.obs;
  final RxBool showInactive = false.obs;
  final RxList<Category> originalCategories = <Category>[].obs;

  // Campos de categoría
  final RxString name = ''.obs;
  final RxString? code = ''.obs;

  // Variable para rastrear la categoría en edición
  final RxString editingCategoryId = ''.obs;

  final dbHelper = DatabaseHelper();

  @override
  void onInit() {
    super.onInit();
    fetchAllCategories();
  }

  void openCategoryForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.onPrincipalBackground,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            top: 16.0,
            left: 16.0,
            right: 16.0,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: CategoryForm(),
        );
      },
    );
  }

  void editCategory(Category category, BuildContext context) {
    editingCategoryId.value = category.id.toString();
    name.value = category.name;
    code?.value = category.code ?? '';
    openCategoryForm(context);
  }

  Future<void> saveCategory() async {
    final isEditing = editingCategoryId.value.isNotEmpty;
    final categoryId = isEditing ? int.tryParse(editingCategoryId.value) : null;

    final existingCategory =
    categoryId != null ? categories.firstWhere((cat) => cat.id == categoryId) : null;

    final category = Category(
      id: categoryId,
      name: name.value,
      code: code?.value?.isEmpty ?? true ? null : code?.value,
      createdAt: categoryId == null
          ? DateTime.now().millisecondsSinceEpoch
          : (existingCategory?.createdAt is int
          ? existingCategory!.createdAt
          : DateTime.parse(existingCategory!.createdAt.toString()).millisecondsSinceEpoch),
      updatedAt: categoryId != null
          ? DateTime.now().millisecondsSinceEpoch
          : null,
      isActive: categoryId == null
          ? true
          : existingCategory?.isActive ?? true,
    );

    try {
      if (categoryId == null) {
        await dbHelper.insertCategory(category);
        CustomSnackbar.show(
          title: "¡Aprobado!",
          message: "Categoría guardada correctamente",
          icon: Icons.check_circle,
          backgroundColor: AppColors.principalGreen,
        );
      } else {
        await dbHelper.updateCategory(category);
        CustomSnackbar.show(
          title: "¡Aprobado!",
          message: "Categoría editada correctamente",
          icon: Icons.check_circle,
          backgroundColor: AppColors.principalGreen,
        );
      }
      fetchAllCategories();
      clearFields();
      editingCategoryId.value = '';
      // Get.back();
    } catch (e) {
      CustomSnackbar.show(
        title: "¡Ocurrió un error!",
        message: "Verifique los datos e intente nuevamente.",
        icon: Icons.cancel,
        backgroundColor: AppColors.invalid,
      );
    }
  }

  Future<void> deactivateCategory(int categoryId) async {
    try {
      final category = await dbHelper.getCategoryById(categoryId);
      if (category != null) {
        category.isActive = false;
        category.updatedAt =  DateTime.now().millisecondsSinceEpoch;
        await dbHelper.updateCategory(category);
        fetchAllCategories();
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
    editingCategoryId.value = '';
  }

  Future<void> fetchAllCategories() async {
    final List<Category> allCategories = await dbHelper.getCategories();
    categories.assignAll(allCategories.where((cat) => cat.isActive));
    originalCategories.assignAll(allCategories);
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