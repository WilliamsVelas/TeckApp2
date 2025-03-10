import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../theme/colors.dart';
import '../../../database/database_helper.dart';
import '../../../database/models/payment_method_model.dart';
import '../widgets/payment_method_form.dart';

class PaymentMethodController extends GetxController {
  final RxList<PaymentMethod> paymentMethods = <PaymentMethod>[].obs;
  final RxString searchQuery = ''.obs;
  final RxString sortCriteria = ''.obs;
  final RxBool showInactive = false.obs;
  final RxList<PaymentMethod> originalPaymentMethods = <PaymentMethod>[].obs;

  // Campos de PaymentMethod
  final RxString name = ''.obs;
  final RxString code = ''.obs;

  final RxString editingPaymentMethodId = ''.obs;

  final dbHelper = DatabaseHelper();

  @override
  void onInit() {
    super.onInit();
    fetchAllPaymentMethods();
  }

  void openPaymentMethodForm(BuildContext context) {
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
          child: PaymentMethodForm(),
        );
      },
    );
  }

  void editPaymentMethod(PaymentMethod paymentMethod, BuildContext context) {
    editingPaymentMethodId.value = paymentMethod.id.toString();
    name.value = paymentMethod.name;
    code.value = paymentMethod.code;
    openPaymentMethodForm(context); // Abrir el formulario con los datos cargados
  }

  Future<void> savePaymentMethod() async {
    final isEditing = editingPaymentMethodId.value.isNotEmpty;
    final paymentMethodId = isEditing ? int.tryParse(editingPaymentMethodId.value) : null;

    final paymentMethod = PaymentMethod(
      id: paymentMethodId,
      name: name.value,
      code: code.value,
      createdAt: paymentMethodId == null
          ? DateTime.now()
          : paymentMethods.firstWhere((pm) => pm.id == paymentMethodId).createdAt,
      updatedAt: DateTime.now(),
      isActive: paymentMethodId == null
          ? true
          : paymentMethods.firstWhere((pm) => pm.id == paymentMethodId).isActive,
    );

    try {
      if (paymentMethodId == null) {
        await dbHelper.insertPaymentMethod(paymentMethod);
      } else {
        await dbHelper.updatePaymentMethod(paymentMethod);
      }
      fetchAllPaymentMethods();
      clearFields();
      editingPaymentMethodId.value = '';
    } catch (e) {
      print('Error al guardar/actualizar el método de pago: $e');
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
    editingPaymentMethodId.value = '';
  }

  void fetchAllPaymentMethods() async {
    final List<PaymentMethod> allPaymentMethods = await dbHelper.getPaymentMethods();
    paymentMethods.assignAll(allPaymentMethods.where((pm) => pm.isActive));
    originalPaymentMethods.assignAll(allPaymentMethods);
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