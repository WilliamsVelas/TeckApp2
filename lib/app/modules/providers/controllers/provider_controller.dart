import 'package:get/get.dart';

import '../../../database/database_helper.dart';
import '../../../database/models/providers_model.dart';

class ProviderController extends GetxController{
  final RxList<Provider> providers = <Provider>[].obs;
  final RxString searchQuery = ''.obs;
  final RxString sortCriteria = ''.obs;

  final RxList<Provider> originalProviders = <Provider>[].obs;

  //Provider
  final RxString name = ''.obs;
  final RxString lastName = ''.obs;
  final RxString businessName = ''.obs;
  final RxString value = ''.obs;

  final dbHelper = DatabaseHelper();

  @override
  void onInit() {
    super.onInit();
    fetchAllProviders();
  }

  Future<void> saveProvider() async {
    final provider = Provider(
      name: name.value,
      lastName: lastName.value,
      businessName: businessName.value,
      value: value.value,
      createdAt: DateTime.now(),
    );

    try {
      await dbHelper.insertProvider(provider);
      fetchAllProviders();
      clearFields();
    } catch (e) {
      print('Error al guardar el proveedor: $e');
    }
  }

  void clearFields() {
    name.value = '';
    lastName.value = '';
    businessName.value = '';
    value.value = '';
  }

  void fetchAllProviders() async {
    final List<Provider> allProviders = await dbHelper.getProviders();
    providers.assignAll(allProviders);
    originalProviders.assignAll(allProviders);
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
    final filtered = originalProviders.where((provider) {
      final matchesSearch = searchQuery.isEmpty ||
          (provider.name.toLowerCase().contains(searchQuery.value.toLowerCase()) ?? false) ||
          (provider.lastName.toLowerCase().contains(searchQuery.value.toLowerCase()) ?? false) ||
          (provider.businessName.toLowerCase().contains(searchQuery.value.toLowerCase()) ?? false);

      return matchesSearch;
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

  Future<void> desactiveProvider(Provider provider) async {
    try {
      await dbHelper.desactiveProvider(provider);
      fetchAllProviders();
    } catch (e) {
      print('Error al desactivar el proveedor: $e');
    }
  }
}