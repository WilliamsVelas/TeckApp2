import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../theme/colors.dart';
import '../../../common/custom_snakcbar.dart';
import '../../../database/database_helper.dart';
import '../../../database/models/bank_account_model.dart';
import '../../../database/models/clients_model.dart';
import '../widgets/bank_account_form.dart';

class BankAccountController extends GetxController {
  // Observables existentes
  final RxList<BankAccount> bankAccounts = <BankAccount>[].obs;
  final RxString searchQuery = ''.obs;
  final RxString sortCriteria = ''.obs;
  final RxBool showInactive = false.obs;
  final RxList<Client> clients = <Client>[].obs;
  final Rx<Client?> selectedClient = Rx<Client?>(null);
  final RxString bankName = ''.obs;
  final RxString numberAccount = ''.obs;
  final RxString code = ''.obs;

  final RxString editingBankAccountId = RxString('');

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

  void editBankAccount(BankAccount bankAccount, BuildContext context) {
    editingBankAccountId.value = bankAccount.id.toString();
    bankName.value = bankAccount.bankName;
    numberAccount.value = bankAccount.numberAccount;
    code.value = bankAccount.code;
    selectedClient.value =
        clients.firstWhere((client) => client.id == bankAccount.clientId);

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
          child: BankAccountForm(),
        );
      },
    );
  }

  Future<void> saveBankAccount() async {
    if (selectedClient.value == null) {
      // Get.snackbar('Error', 'Por favor, selecciona un Cliente.', backgroundColor: Colors.red);
      return;
    }

    final isEditing = editingBankAccountId.value.isNotEmpty;
    final bankAccountId =
        isEditing ? int.tryParse(editingBankAccountId.value) : null;

    final bankAccount = BankAccount(
      id: bankAccountId,
      bankName: bankName.value,
      numberAccount: numberAccount.value,
      code: code.value,
      clientId: selectedClient.value!.id!,
      createdAt: bankAccountId == null
          ? DateTime.now()
          : bankAccounts.firstWhere((ba) => ba.id == bankAccountId).createdAt,
      updatedAt: bankAccountId != null ? DateTime.now() : null,
      isActive: bankAccountId == null
          ? true
          : bankAccounts.firstWhere((ba) => ba.id == bankAccountId).isActive,
    );

    try {
      if (bankAccountId == null) {
        await dbHelper.insertBankAccount(bankAccount);
        CustomSnackbar.show(
          title: "¡Aprobado!",
          message: "Cuenta de banco guardada correctamente",
          icon: Icons.check_circle,
          backgroundColor: AppColors.principalGreen,
        );
      } else {
        await dbHelper.updateBankAccount(bankAccount);
        CustomSnackbar.show(
          title: "¡Aprobado!",
          message: "Cuenta de banco editada correctamente",
          icon: Icons.check_circle,
          backgroundColor: AppColors.principalGreen,
        );
      }
      fetchAllBankAccounts();
      clearFields();
      editingBankAccountId.value = '';
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

  Future<void> deactivateBankAccount(int bankAccountId) async {
    try {
      final bankAccount = await dbHelper.getBankAccountById(bankAccountId);
      if (bankAccount != null) {
        bankAccount.isActive = false;
        bankAccount.updatedAt = DateTime.now();
        await dbHelper.updateBankAccount(bankAccount);
        fetchAllBankAccounts();
        print('Cuenta bancaria desactivada con ID: $bankAccountId');
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
    editingBankAccountId.value = '';
  }

  void fetchAllBankAccounts() async {
    final List<BankAccount> allBankAccounts = await dbHelper.getBankAccounts();
    bankAccounts.assignAll(allBankAccounts.where((ba) => ba.isActive));
    applyFilters();
  }

  Future<void> fetchAllClients() async {
    final List<Client> allClients = await dbHelper.getClients();
    clients.assignAll(allClients);
  }

  Future<String> getClientName(int clientId) async {
    Client? client = await dbHelper.getClientById(clientId);
    return "${client?.name} ${client?.lastName}";
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
          bankAccount.bankName
              .toLowerCase()
              .contains(searchQuery.value.toLowerCase()) ||
          bankAccount.numberAccount
              .toLowerCase()
              .contains(searchQuery.value.toLowerCase()) ||
          bankAccount.code
              .toLowerCase()
              .contains(searchQuery.value.toLowerCase());

      final matchesStatus = showInactive.value || bankAccount.isActive;

      return matchesSearch && matchesStatus;
    },).toList();

    if (sortCriteria.value == 'date') {
      filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } else if (sortCriteria.value == 'bankName') {
      filtered.sort((a, b) => a.bankName.compareTo(b.bankName));
    }

    bankAccounts.value = filtered;
  }
}
