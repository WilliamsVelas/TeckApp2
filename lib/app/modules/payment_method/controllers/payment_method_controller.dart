import 'package:get/get.dart';

import '../../../database/database_helper.dart';
import '../../../database/models/payment_method_model.dart';

class PaymentMethodController extends GetxController{
  final RxList<PaymentMethod> paymentMethods = <PaymentMethod>[].obs;
  final RxString searchQuery = ''.obs;
  final RxString sortCriteria = ''.obs;

  final RxList<PaymentMethod> originalPaymentMethods = <PaymentMethod>[].obs;

  //PaymentMethod
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

  void clearFields() {
    name.value = '';
    code.value = '';
  }

  void fetchAllPaymentMethods() async {
    final List<PaymentMethod> allPaymentMethods = await dbHelper.getPaymentMethods();
    paymentMethods.assignAll(allPaymentMethods);
    originalPaymentMethods.assignAll(allPaymentMethods);
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
    final filtered = originalPaymentMethods.where((paymentMethod) {
      final matchesSearch = searchQuery.isEmpty ||
          paymentMethod.name.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          paymentMethod.code.toLowerCase().contains(searchQuery.value.toLowerCase());

      return matchesSearch;
    }).toList();

    if (sortCriteria.value == 'date') {
      filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } else if (sortCriteria.value == 'name') {
      filtered.sort((a, b) => a.name.compareTo(b.name));
    }

    paymentMethods.value = filtered;
  }

}