import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../theme/colors.dart';
import '../../../common/custom_snakcbar.dart';
import '../../../database/database_helper.dart';
import '../../../database/models/bank_account_model.dart';
import '../../../database/models/clients_model.dart';
import '../widgets/clients_card.dart';
import '../widgets/clients_form.dart';

class ClientsController extends GetxController {
  final RxList<Client> clients = <Client>[].obs;
  final RxString searchQuery = ''.obs;
  final RxString sortCriteria = ''.obs;
  final RxBool showInactive = false.obs;
  final RxList<Client> originalClients = <Client>[].obs;

  final RxList<BankAccount> clientBankAccounts = <BankAccount>[].obs;
  final RxBool isLoadingBankAccounts = false.obs;

  // Campos de Client
  final RxString name = ''.obs;
  final RxString lastName = ''.obs;
  final RxString businessName = ''.obs;
  final RxString affiliateCode = ''.obs;
  final RxString value = ''.obs;

  // Variable para rastrear el cliente en edición
  final RxString editingClientId = ''.obs;

  final dbHelper = DatabaseHelper();

  @override
  void onInit() {
    super.onInit();
    fetchAllClients();
  }

  void openClientForm(BuildContext context) {
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
          child: ClientForm(),
        );
      },
    );
  }

  void editClient(Client client, BuildContext context) {
    editingClientId.value = client.id.toString();
    name.value = client.name;
    lastName.value = client.lastName;
    businessName.value = client.businessName;
    affiliateCode.value = client.affiliateCode;
    value.value = client.value;
    openClientForm(context);
  }

  Future<void> saveClient() async {
    final isEditing = editingClientId.value.isNotEmpty;
    final clientId = isEditing ? int.tryParse(editingClientId.value) : null;

    final client = Client(
      id: clientId,
      name: name.value,
      lastName: lastName.value,
      businessName: businessName.value,
      affiliateCode: affiliateCode.value,
      value: value.value,
      createdAt: clientId == null
          ? DateTime.now()
          : clients.firstWhere((c) => c.id == clientId).createdAt,
      updatedAt: clientId != null ? DateTime.now() : null,
      isActive: clientId == null
          ? true
          : clients.firstWhere((c) => c.id == clientId).isActive,
    );

    try {
      if (clientId == null) {
        await dbHelper.insertClient(client);
        CustomSnackbar.show(
          title: "¡Aprobado!",
          message: "Cliente guardado correctamente",
          icon: Icons.check_circle,
          backgroundColor: AppColors.principalGreen,
        );
      } else {
        await dbHelper.updateClient(client);
        CustomSnackbar.show(
          title: "¡Aprobado!",
          message: "Cliente editado correctamente",
          icon: Icons.check_circle,
          backgroundColor: AppColors.principalGreen,
        );
      }
      fetchAllClients();
      clearFields();
      editingClientId.value = '';
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

  Future<void> deactivateClient(int clientId) async {
    try {
      final client = await dbHelper.getClientById(clientId);
      if (client != null) {
        client.isActive = false;
        client.updatedAt = DateTime.now();
        await dbHelper.updateClient(client);
        fetchAllClients();
        print('Cliente desactivado con ID: $clientId');
      } else {
        print('Cliente con ID $clientId no encontrado');
      }
    } catch (e) {
      print('Error al desactivar el cliente: $e');
    }
  }

  void clearFields() {
    name.value = '';
    lastName.value = '';
    businessName.value = '';
    affiliateCode.value = '';
    value.value = '';
    editingClientId.value = '';
  }

  void fetchAllClients() async {
    final List<Client> allClients = await dbHelper.getClients();
    clients.assignAll(allClients.where((client) => client.isActive));
    originalClients.assignAll(allClients);
    applyFilters();
  }

  void toggleShowInactive(bool value) {
    showInactive.value = value;
    applyFilters();
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
          client.lastName
              .toLowerCase()
              .contains(searchQuery.value.toLowerCase()) ||
          client.businessName
              .toLowerCase()
              .contains(searchQuery.value.toLowerCase()) ||
          client.affiliateCode
              .toLowerCase()
              .contains(searchQuery.value.toLowerCase());
      final matchesStatus = showInactive.value || client.isActive;
      return matchesSearch && matchesStatus;
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

  //banck accounts
  Future<void> loadClientBankAccounts(int clientId) async {
    try {
      isLoadingBankAccounts.value = true;
      final accounts = await dbHelper.getBankAccountsByClientId(clientId);
      clientBankAccounts.assignAll(accounts);
    } catch (e) {
      CustomSnackbar.show(
        title: "¡Ocurrió un error!",
        message: "Error al cargar cuentas bancarias.",
        icon: Icons.cancel,
        backgroundColor: AppColors.invalid,
      );
    } finally {
      isLoadingBankAccounts.value = false;
    }
  }

  void showBankAccountsModal(int clientId, BuildContext context) {
    loadClientBankAccounts(clientId);
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
          child: BankAccountsModal(clientId: clientId),
        );
      },
    );
  }
}
