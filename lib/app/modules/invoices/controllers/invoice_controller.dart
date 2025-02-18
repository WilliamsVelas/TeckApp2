import 'package:get/get.dart';

import '../../../database/database_helper.dart';
import '../../../database/models/invoice_lines_model.dart';
import '../../../database/models/invoices_model.dart';
import '../../../database/models/products_model.dart';
import '../../../database/models/serials_model.dart';

class InvoiceController extends GetxController{
  final RxList<Invoice> invoices = <Invoice>[].obs;
  final RxString searchQuery = ''.obs;
  final RxString sortCriteria = ''.obs;
  final RxList<Invoice> originalInvoices = <Invoice>[].obs;

  // Observables for InvoiceLine
  final RxList<InvoiceLine> invoiceLines = <InvoiceLine>[].obs;

  // Selector de producto
  final Rx<Product?> selectedProduct = Rx<Product?>(null);

  // Seriales del producto seleccionado
  final RxList<Serial> availableSerials = <Serial>[].obs;

  // Seriales seleccionados para la línea de factura
  final RxList<Serial> selectedInvoiceSerials = <Serial>[].obs;

  // InvoiceForm Fields
  final RxString documentNo = ''.obs;
  final RxString type = ''.obs;
  final RxString totalAmount = ''.obs;
  final RxString totalPayed = ''.obs;
  final RxInt qty = 0.obs;
  final RxInt clientId = 0.obs;
  final RxInt bankAccountId = 0.obs;
  final RxInt productId = 0.obs;

  // DAO
  final dbHelper = DatabaseHelper();

  @override
  void onInit() {
    super.onInit();
    fetchAllInvoices();
  }

  void removeInvoiceLine(int index) {
    invoiceLines.removeAt(index);
  }

  void selectProduct(Product? product) async {
    selectedProduct.value = product;
    availableSerials.clear(); // Limpiar la lista anterior

    if (product != null) {
      // Cargar seriales solo si hay un producto seleccionado
      final serials = await dbHelper.getSerialsByProductId(product.id!);
      availableSerials.assignAll(serials);
    }
  }

  // Función para agregar un serial a la línea de factura
  void addSerialToInvoice(Serial serial) {
    if (!selectedInvoiceSerials.contains(serial)) {
      selectedInvoiceSerials.add(serial);
    }
  }

  // Función para remover un serial de la línea de factura
  void removeSerialFromInvoice(Serial serial) {
    selectedInvoiceSerials.remove(serial);
  }

  Future<void> saveInvoice() async {
    if (selectedInvoiceSerials.isEmpty) {
      // Get.snackbar('Error', 'Debe seleccionar al menos un serial.',
      //     backgroundColor: Colors.red);
      return;
    }

    double totalAmountValue = 0.0;
    for (var serial in selectedInvoiceSerials) {
      // Get Price
      Product product = await dbHelper.getProductById(serial.productId) ?? Product(name: "", code: "", price: 0.0, createdAt: DateTime.now());
      totalAmountValue = totalAmountValue + product.price;
    }
    totalAmount.value = totalAmountValue.toString();

    double parsedTotalAmount = 0.0;
    try {
      parsedTotalAmount = double.parse(totalAmount.value);
    } catch (e) {
      print('Error al convertir el totalAmount: $e');
      // Get.snackbar('Error', 'Por favor, ingrese un totalAmount válido.',
      //     backgroundColor: Colors.red); // Optional: Show error message to user
      return; // Stop the save operation
    }

    double parsedTotalPayed = 0.0;
    try {
      parsedTotalPayed = double.parse(totalPayed.value);
    } catch (e) {
      print('Error al convertir el totalPayed: $e');
      // Get.snackbar('Error', 'Por favor, ingrese un totalPayed válido.',
      //     backgroundColor: Colors.red); // Optional: Show error message to user
      return;
    }

    final invoice = Invoice(
      documentNo: documentNo.value,
      type: type.value,
      totalAmount: parsedTotalAmount,
      totalPayed: parsedTotalPayed,
      refTotalAmount: parsedTotalAmount,
      refTotalPayed: parsedTotalPayed,
      qty: selectedInvoiceSerials.length,
      clientId: clientId.value,
      bankAccountId: bankAccountId.value,
      productId:
      selectedProduct.value?.id ?? 0,
      createdAt: DateTime.now(),
    );

    try {
      int invoiceId = await dbHelper.insertInvoice(invoice);
      print('Factura guardada con ID: $invoiceId');

      for (var serial in selectedInvoiceSerials) {
        // Serial product = await dbHelper.getSerialById(serial.id?? 0)??Serial(productId: 0, serial: "", createdAt: DateTime.now());
        // final invoiceLine = InvoiceLine(
        //   productName: product.serial,
        //   productPrice: 0.0,
        //   refProductPrice: 0.0,
        //   total: 0.0,
        //   productId: product.productId,
        //   productSerial: product.serial,
        //   invoiceId: invoiceId,
        //   createdAt: DateTime.now(),
        // );
        // await dbHelper.insertInvoiceLine(invoiceLine);
      }
      print('Linea de Seriales guardados para la factura $invoiceId');

      fetchAllInvoices();
      clearFields();
      Get.back();
    } catch (e) {
      print('Error al guardar la factura y/o los seriales: $e');
    }
  }

  void clearFields() {
    documentNo.value = '';
    type.value = '';
    totalAmount.value = '';
    totalPayed.value = '';
    qty.value = 0;
    clientId.value = 0;
    bankAccountId.value = 0;
    productId.value = 0;
  }

  void fetchAllInvoices() async {
    final List<Invoice> allInvoices = await dbHelper.getInvoices();
    invoices.assignAll(allInvoices);
    originalInvoices.assignAll(allInvoices);
  }

  void searchInvoices(String query) {
    searchQuery.value = query;
    applyFilters();
  }

  void sortInvoices(String criteria) {
    sortCriteria.value = criteria;
    applyFilters();
  }

  void applyFilters() {
    final filtered = originalInvoices.where((invoice) {
      final matchesSearch = searchQuery.isEmpty ||
          invoice.documentNo.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          invoice.type.toLowerCase().contains(searchQuery.value.toLowerCase());

      return matchesSearch;
    }).toList();

    if (sortCriteria.value == 'date') {
      filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } else if (sortCriteria.value == 'totalAmount') {
      filtered.sort((a, b) => a.totalAmount.compareTo(b.totalAmount));
    }

    invoices.value = filtered;
  }
}