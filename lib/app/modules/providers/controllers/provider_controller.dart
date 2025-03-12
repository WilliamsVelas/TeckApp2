import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../theme/colors.dart';
import '../../../database/database_helper.dart';
import '../../../database/models/providers_model.dart';
import '../widgets/provider_form.dart';

class ProviderController extends GetxController {
  final RxList<Provider> providers = <Provider>[].obs;
  final RxString searchQuery = ''.obs;
  final RxString sortCriteria = ''.obs;
  final RxBool showInactive = false.obs;
  final RxList<Provider> originalProviders = <Provider>[].obs;

  // Campos de Provider
  final RxString name = ''.obs;
  final RxString lastName = ''.obs;
  final RxString businessName = ''.obs;
  final RxString value = ''.obs;

  // Variable para rastrear el proveedor en edición
  final RxString editingProviderId = ''.obs;

  final dbHelper = DatabaseHelper();

  @override
  void onInit() {
    super.onInit();
    fetchAllProviders();
  }

  void openProviderForm(BuildContext context) {
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
          child: ProviderForm(),
        );
      },
    );
  }

  void editProvider(Provider provider, BuildContext context) {
    editingProviderId.value = provider.id.toString();
    name.value = provider.name;
    lastName.value = provider.lastName;
    businessName.value = provider.businessName;
    value.value = provider.value;
    openProviderForm(context);
  }

  Future<void> saveProvider() async {
    final isEditing = editingProviderId.value.isNotEmpty;
    final providerId = isEditing ? int.tryParse(editingProviderId.value) : null;

    final provider = Provider(
      id: providerId,
      name: name.value,
      lastName: lastName.value,
      businessName: businessName.value,
      value: value.value,
      createdAt: providerId == null
          ? DateTime.now().millisecondsSinceEpoch
          : providers.firstWhere((p) => p.id == providerId).createdAt,
      updatedAt: providerId != null ? DateTime.now().millisecondsSinceEpoch : null,
      isActive: providerId == null
          ? true
          : providers.firstWhere((p) => p.id == providerId).isActive,
    );

    try {
      if (providerId == null) {
        await dbHelper.insertProvider(provider);
      } else {
        await dbHelper.updateProvider(provider);
      }
      fetchAllProviders();
      clearFields();
      editingProviderId.value = '';
      // Get.back();
    } catch (e) {
      print('Error al guardar/actualizar el proveedor: $e');
    }
  }

  Future<void> deactivateProvider(int providerId) async {
    try {
      final provider = await dbHelper.getProviderById(providerId);
      if (provider != null) {
        provider.isActive = false;
        provider.updatedAt = DateTime.now().millisecondsSinceEpoch;
        await dbHelper.updateProvider(provider);
        fetchAllProviders();
        print('Proveedor desactivado con ID: $providerId');
      } else {
        print('Proveedor con ID $providerId no encontrado');
      }
    } catch (e) {
      print('Error al desactivar el proveedor: $e');
    }
  }

  void clearFields() {
    name.value = '';
    lastName.value = '';
    businessName.value = '';
    value.value = '';
    editingProviderId.value = '';
  }

  void fetchAllProviders() async {
    final List<Provider> allProviders = await dbHelper.getProviders();
    providers.assignAll(allProviders.where((prov) => prov.isActive));
    originalProviders.assignAll(allProviders);
    applyFilters();
  }

  void toggleShowInactive(bool value) {
    showInactive.value = value;
    applyFilters();
  }

  void searchProviders(String query) {
    searchQuery.value = query;
    applyFilters();
  }

  void sortProviders(String criteria) {
    sortCriteria.value = criteria;
    applyFilters();
  }

  void applyFilters() {
    var filtered = originalProviders.where((provider) {
      final matchesSearch = searchQuery.isEmpty ||
          (provider.name.toLowerCase().contains(searchQuery.value.toLowerCase()) ?? false) ||
          (provider.lastName.toLowerCase().contains(searchQuery.value.toLowerCase()) ?? false) ||
          (provider.businessName.toLowerCase().contains(searchQuery.value.toLowerCase()) ?? false);
      final matchesStatus = showInactive.value || provider.isActive;
      return matchesSearch && matchesStatus;
    }).toList();

    if (sortCriteria.value == 'date') {
      filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } else if (sortCriteria.value == 'name') {
      filtered.sort((a, b) => a.name.compareTo(b.name ?? '') ?? 0);
    } else if (sortCriteria.value == 'lastName') {
      filtered.sort((a, b) => a.lastName.compareTo(b.lastName ?? '') ?? 0);
    }

    providers.value = filtered;
  }
}