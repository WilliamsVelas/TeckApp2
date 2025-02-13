import 'package:get/get.dart';

import '../../../database/database_helper.dart';
import '../../../database/models/clients_model.dart';

class ClientsController extends GetxController{
  final RxList<Client> clients = <Client>[].obs;
  final RxString searchQuery = ''.obs;
  final RxString sortCriteria = ''.obs;

  final RxList<Client> originalClients = <Client>[].obs;

  //Client
  final RxString name = ''.obs;
  final RxString lastName = ''.obs;
  final RxString businessName = ''.obs;
  final RxString bankAccount = ''.obs;
  final RxString codeBank = ''.obs;
  final RxString affiliateCode = ''.obs;
  final RxString value = ''.obs;

  final dbHelper = DatabaseHelper();

  @override
  void onInit() {
    super.onInit();
    fetchAllClients();
  }

  Future<void> saveClient() async {
    final client = Client(
      name: name.value,
      lastName: lastName.value,
      businessName: businessName.value,
      bankAccount: bankAccount.value,
      codeBank: codeBank.value,
      affiliateCode: affiliateCode.value,
      value: value.value,
      createdAt: DateTime.now(),
    );

    try {
      await dbHelper.insertClient(client);
      fetchAllClients();
      clearFields();
    } catch (e) {
      print('Error al guardar el cliente: $e');
    }
  }

  void clearFields() {
    name.value = '';
    lastName.value = '';
    businessName.value = '';
    bankAccount.value = '';
    codeBank.value = '';
    affiliateCode.value = '';
    value.value = '';
  }

  void fetchAllClients() async {
    final List<Client> allClients = await dbHelper.getClients();
    clients.assignAll(allClients);
    originalClients.assignAll(allClients);
  }

  void searchClients(String query) {
    searchQuery.value = query;
    applyFilters();
  }

  void sortClients(String criteria) {
    sortCriteria.value = criteria;
    applyFilters();
  }

  void applyFilters() {
    final filtered = originalClients.where((client) {
      final matchesSearch = searchQuery.isEmpty ||
          client.name.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          client.lastName.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          client.businessName.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          client.affiliateCode.toLowerCase().contains(searchQuery.value.toLowerCase());

      return matchesSearch;
    }).toList();

    if (sortCriteria.value == 'date') {
      filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } else if (sortCriteria.value == 'name') {
      filtered.sort((a, b) => a.name.compareTo(b.name));
    } else if (sortCriteria.value == 'lastName') {
      filtered.sort((a, b) => a.lastName.compareTo(b.lastName));
    }

    clients.value = filtered;
  }

  Future<void> desactiveClient(Client client) async {
    try {
      await dbHelper.desactiveClient(client);
      fetchAllClients(); // Refresh the list after deactivation
    } catch (e) {
      print('Error al desactivar el cliente: $e');
    }
  }
}