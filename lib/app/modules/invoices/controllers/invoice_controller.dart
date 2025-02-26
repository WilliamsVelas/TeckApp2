import 'package:get/get.dart';

import '../../../database/database_helper.dart';
import '../../../database/models/clients_model.dart';
import '../../../database/models/invoice_lines_model.dart';
import '../../../database/models/invoices_model.dart';
import '../../../database/models/products_model.dart';
import '../../../database/models/serials_model.dart';

class InvoiceController extends GetxController {
  final RxList<Invoice> invoices = <Invoice>[].obs;
  final RxString searchQuery = ''.obs;
  final RxString sortCriteria = ''.obs;
  final RxList<Invoice> originalInvoices = <Invoice>[].obs;

  final RxList<InvoiceLine> invoiceLines = <InvoiceLine>[].obs;

  final Rx<Product?> selectedProduct = Rx<Product?>(null);
  final RxList<Product> products = <Product>[].obs;

  final RxList<Serial> availableSerials = <Serial>[].obs;
  final Rx<Serial?> selectedSerial = Rx<Serial?>(null);

  final RxList<Client> clients = <Client>[].obs;
  final Rx<Client?> selectedClient = Rx<Client?>(null);

  final RxString documentNo = ''.obs;
  final RxString totalPayed = ''.obs;
  final RxString type = ''.obs;
  final RxInt qty = 0.obs;

  final DatabaseHelper dbHelper = DatabaseHelper();

  @override
  void onInit() {
    super.onInit();
    fetchAllInvoices();
  }

  void fetchAll() {
    fetchAllProducts();
    fetchAllClients();
  }

  Future<void> fetchAllClients() async {
    final List<Client> allClients = await dbHelper.getClients();
    clients.assignAll(allClients);
  }

  Future<String> getClientName(int clientId) async {
    Client? client = await dbHelper.getClientById(clientId);
    return client?.businessName ?? 'N/A';
  }

  void selectProduct(Product? product) async {
    selectedProduct.value = product;
    availableSerials.clear();
    selectedSerial.value = null;
    if (product != null) {
      final List<Serial> serials =
          await dbHelper.getSerialsByProductId(product.id!);
      availableSerials.assignAll(serials);
    }
  }

  void selectClient(Client? client) {
    selectedClient.value = client;
  }

  Future<void> fetchAllProducts() async {
    final List<Product> allProducts = await dbHelper.getProducts();
    products.assignAll(allProducts);
  }

  void selectSerial(Serial? serial) {
    selectedSerial.value = serial;
  }

  void addInvoiceLine() {
    if (selectedProduct.value == null || selectedSerial.value == null) {
      // Get.snackbar('Error', 'Debe seleccionar un producto y un serial.');
      return;
    }

    final invoiceLine = InvoiceLine(
      productName: selectedProduct.value!.name,
      productPrice: selectedProduct.value!.price,
      refProductPrice: selectedProduct.value!.price,
      total: selectedProduct.value!.price,
      productId: selectedProduct.value!.id!,
      productSerial: selectedSerial.value!.serial,
      invoiceId: 0,
      createdAt: DateTime.now(),
    );

    invoiceLines.add(invoiceLine);
    qty.value += 1;
    selectedProduct.value = null;
    selectedSerial.value = null;
    availableSerials.clear();
  }

  double calculateTotalAmount() {
    return invoiceLines.fold(0.0, (sum, line) => sum + line.total);
  }

  double calculateAmount() {
    final totalAmount = calculateTotalAmount();
    final parsedTotalPayed = double.tryParse(totalPayed.value) ?? 0.0;
    return totalAmount - parsedTotalPayed;
  }

  Future<void> saveInvoice() async {
    if (invoiceLines.isEmpty) {
      Get.snackbar('Error', 'Debe agregar al menos una línea de factura.');
      return;
    }
    if (selectedClient.value == null) {
      Get.snackbar('Error', 'Debe seleccionar un cliente.');
      return;
    }
    if (documentNo.value.isEmpty) {
      Get.snackbar('Error', 'El número de documento es obligatorio.');
      return;
    }

    final parsedTotalPayed = double.tryParse(totalPayed.value) ?? 0.0;
    final totalAmount = calculateTotalAmount();

    if (parsedTotalPayed == totalAmount) {
      type.value = "INV_P";
    } else {
      type.value = "INV_N_P";
    }

    final invoice = Invoice(
      documentNo: documentNo.value,
      type: type.value,
      totalAmount: totalAmount,
      totalPayed: parsedTotalPayed,
      refTotalAmount: totalAmount,
      refTotalPayed: parsedTotalPayed,
      qty: qty.value,
      clientId: selectedClient.value!.id!,
      createdAt: DateTime.now(),
    );

    try {
      final invoiceId = await dbHelper.insertInvoice(invoice);
      for (var line in invoiceLines) {
        final updatedLine = InvoiceLine(
          productName: line.productName,
          productPrice: line.productPrice,
          refProductPrice: line.refProductPrice,
          total: line.total,
          refTotal: line.refTotal,
          productId: line.productId,
          productSerial: line.productSerial,
          invoiceId: invoiceId,
          createdAt: line.createdAt,
        );
        await dbHelper.insertInvoiceLine(updatedLine);
      }

      // Get.snackbar('Éxito', 'Factura guardada correctamente');
      Get.back();
      clearFields();
      fetchAllInvoices();
    } catch (e) {
      // Get.snackbar('Error', 'No se pudo guardar la factura: ${e.toString()}');
    }
  }

  void clearFields() {
    documentNo.value = '';
    totalPayed.value = '';
    type.value = '';
    qty.value = 0;
    selectedClient.value = null;
    selectedProduct.value = null;
    selectedSerial.value = null;
    invoiceLines.clear();
    availableSerials.clear();
    clients.clear();
    products.clear();
  }

  Future<void> fetchAllInvoices() async {
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
          invoice.documentNo
              .toLowerCase()
              .contains(searchQuery.value.toLowerCase()) ||
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