import 'package:get/get.dart';

import '../../../database/database_helper.dart';
import '../../../database/models/bank_account_model.dart';
import '../../../database/models/clients_model.dart';

class BankAccountController extends GetxController {
  // Observables for BankAccounts
  final RxList<BankAccount> bankAccounts = <BankAccount>[].obs;
  final RxString searchQuery = ''.obs; // Añadido para filtros futuros
  final RxString sortCriteria = ''.obs; // Añadido para filtros futuros
  final RxBool showInactive = false.obs; // Nuevo: Mostrar cuentas desactivadas

  // Client
  final RxList<Client> clients = <Client>[].obs;
  final Rx<Client?> selectedClient = Rx<Client?>(null);

  // BankAccount Fields
  final RxString bankName = ''.obs;
  final RxString numberAccount = ''.obs;
  final RxString code = ''.obs;

  // DAO
  final dbHelper = DatabaseHelper();

  @override
  void onInit() {
    super.onInit();
    fetchAllBankAccounts();
    fetchAllClients();
  }

  void selectClient(Client? client) {
    selectedClient.value = client;
  }

  // CRUD
  Future<void> saveBankAccount() async {
    // 1. Validate Data
    if (selectedClient.value == null) {
      // Get.snackbar('Error', 'Por favor, selecciona un Cliente.', backgroundColor: Colors.red);
      return;
    }
    // 2. Create bankAccount
    final bankAccount = BankAccount(
      bankName: bankName.value,
      numberAccount: numberAccount.value,
      code: code.value,
      clientId: selectedClient.value!.id!,
      createdAt: DateTime.now(),
    );

    try {
      await dbHelper.insertBankAccount(bankAccount);
      fetchAllBankAccounts();
      clearFields();
      Get.back();
    } catch (e) {
      print('Error al guardar la cuenta bancaria: $e');
    }
  }

  Future<void> deactivateBankAccount(int bankAccountId) async {
    try {
      final bankAccount = await dbHelper.getBankAccountById(bankAccountId);
      if (bankAccount != null) {
        bankAccount.isActive = false;
        bankAccount.updatedAt = DateTime.now();
        await dbHelper.updateBankAccount(bankAccount);
        fetchAllBankAccounts();
        print('Cuenta bancaria desactivada con ID: $bankAccountId');
      } else {
        print('Cuenta bancaria con ID $bankAccountId no encontrada');
      }
    } catch (e) {
      print('Error al desactivar la cuenta bancaria: $e');
    }
  }

  void clearFields() {
    bankName.value = '';
    numberAccount.value = '';
    code.value = '';
    selectedClient.value = null;
  }

  void fetchAllBankAccounts() async {
    final List<BankAccount> allBankAccounts = await dbHelper.getBankAccounts();
    bankAccounts.assignAll(allBankAccounts.where((ba) => ba.isActive)); // Solo activas por defecto
    // Si necesitas todas las cuentas para filtros futuros:
    // originalBankAccounts.assignAll(allBankAccounts);
    applyFilters();
  }

  Future<void> fetchAllClients() async {
    final List<Client> allClients = await dbHelper.getClients();
    clients.assignAll(allClients);
  }

  Future<String> getClientName(int clientId) async {
    Client? client = await dbHelper.getClientById(clientId);
    return client?.businessName ?? 'N/A';
  }

  void toggleShowInactive(bool value) {
    showInactive.value = value;
    applyFilters();
  }

  void searchBankAccounts(String query) {
    searchQuery.value = query;
    applyFilters();
  }

  void sortBankAccounts(String criteria) {
    sortCriteria.value = criteria;
    applyFilters();
  }

  void applyFilters() {
    final filtered = bankAccounts.where((bankAccount) {
      final matchesSearch = searchQuery.isEmpty ||
          bankAccount.bankName.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          bankAccount.numberAccount.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          bankAccount.code.toLowerCase().contains(searchQuery.value.toLowerCase());

      final matchesStatus = showInactive.value || bankAccount.isActive;

      return matchesSearch && matchesStatus;
    }).toList();

    if (sortCriteria.value == 'date') {
      filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } else if (sortCriteria.value == 'bankName') {
      filtered.sort((a, b) => a.bankName.compareTo(b.bankName));
    }

    bankAccounts.value = filtered;
  }
}