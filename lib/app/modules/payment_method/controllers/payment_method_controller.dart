import 'package:get/get.dart';

import '../../../database/database_helper.dart';
import '../../../database/models/payment_method_model.dart';

class PaymentMethodController extends GetxController {
  final RxList<PaymentMethod> paymentMethods = <PaymentMethod>[].obs;
  final RxString searchQuery = ''.obs;
  final RxString sortCriteria = ''.obs;
  final RxBool showInactive = false.obs; // Nuevo: Mostrar métodos desactivados

  final RxList<PaymentMethod> originalPaymentMethods = <PaymentMethod>[].obs;

  // PaymentMethod
  final RxString name = ''.obs;
  final RxString code = ''.obs;

  final dbHelper = DatabaseHelper();

  @override
  void onInit() {
    super.onInit();
    fetchAllPaymentMethods();
  }

  Future<void> savePaymentMethod() async {
    final paymentMethod = PaymentMethod(
      name: name.value,
      code: code.value,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    try {
      await dbHelper.insertPaymentMethod(paymentMethod);
      fetchAllPaymentMethods();
      clearFields();
    } catch (e) {
      print('Error al guardar el método de pago: $e');
    }
  }

  Future<void> deactivatePaymentMethod(int paymentMethodId) async {
    try {
      final paymentMethod = await dbHelper.getPaymentMethodById(paymentMethodId);
      if (paymentMethod != null) {
        paymentMethod.isActive = false;
        paymentMethod.updatedAt = DateTime.now();
        await dbHelper.updatePaymentMethod(paymentMethod);
        fetchAllPaymentMethods();
        print('Método de pago desactivado con ID: $paymentMethodId');
      } else {
        print('Método de pago con ID $paymentMethodId no encontrado');
      }
    } catch (e) {
      print('Error al desactivar el método de pago: $e');
    }
  }

  void clearFields() {
    name.value = '';
    code.value = '';
  }

  void fetchAllPaymentMethods() async {
    final List<PaymentMethod> allPaymentMethods = await dbHelper.getPaymentMethods();
    paymentMethods.assignAll(allPaymentMethods.where((pm) => pm.isActive)); // Solo activas por defecto
    originalPaymentMethods.assignAll(allPaymentMethods); // Todas, incluidas inactivas
    applyFilters();
  }

  void toggleShowInactive(bool value) {
    showInactive.value = value;
    applyFilters();
  }

  void searchPaymentMethods(String query) {
    searchQuery.value = query;
    applyFilters();
  }

  void sortPaymentMethods(String criteria) {
    sortCriteria.value = criteria;
    applyFilters();
  }

  void applyFilters() {
    var filtered = originalPaymentMethods.where((paymentMethod) {
      final matchesSearch = searchQuery.isEmpty ||
          paymentMethod.name.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          paymentMethod.code.toLowerCase().contains(searchQuery.value.toLowerCase());

      final matchesStatus = showInactive.value || paymentMethod.isActive;

      return matchesSearch && matchesStatus;
    }).toList();

    if (sortCriteria.value == 'date') {
      filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } else if (sortCriteria.value == 'name') {
      filtered.sort((a, b) => a.name.compareTo(b.name));
    }

    paymentMethods.value = filtered;
  }
}