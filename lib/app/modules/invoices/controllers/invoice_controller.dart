import 'package:get/get.dart';

import '../../../database/database_helper.dart';
import '../../../database/models/clients_model.dart';
import '../../../database/models/invoice_lines_model.dart';
import '../../../database/models/invoices_model.dart';
import '../../../database/models/products_model.dart';
import '../../../database/models/serials_model.dart';

class InvoiceController extends GetxController {
  // Lista de facturas
  final RxList<Invoice> invoices = <Invoice>[].obs;

  // Búsqueda y ordenamiento
  final RxString searchQuery = ''.obs;
  final RxString sortCriteria = ''.obs;
  final RxList<Invoice> originalInvoices = <Invoice>[].obs;

  // Líneas de factura
  final RxList<InvoiceLine> invoiceLines = <InvoiceLine>[].obs;

  // Producto seleccionado
  final Rx<Product?> selectedProduct = Rx<Product?>(null);
  final RxList<Product> products = <Product>[].obs;

  // Seriales disponibles para el producto seleccionado
  final RxList<Serial> availableSerials = <Serial>[].obs;

  // Serial seleccionado para la factura
  final Rx<Serial?> selectedSerial = Rx<Serial?>(null);

  final RxList<Client> clients = <Client>[].obs;
  final Rx<Client?> selectedClient = Rx<Client?>(null);
  // Campos del formulario de factura
  final RxString documentNo = ''.obs;
  final RxString type = ''.obs;
  final RxString totalAmount = ''.obs;
  final RxString totalPayed = ''.obs;
  final RxInt qty = 0.obs;
  final RxInt clientId = 0.obs;
  final RxInt bankAccountId = 0.obs;

  // DAO
  final DatabaseHelper dbHelper = DatabaseHelper();

  @override
  void onInit() {
    super.onInit();
    fetchAllProducts();
    fetchAllInvoices();
  }

  void selectProduct(Product? product) async {
    selectedProduct.value = product;
    availableSerials.clear();
    selectedSerial.value = null;
    print("producto seleccionado: ${product?.id}");

    if (product != null) {
      print("producto seleccionado: ${product?.id}");
      final List<Serial> serials = await dbHelper.getSerialsByProductId(product.id!);
      print("seriales: $serials");

      availableSerials.assignAll(serials);
      availableSerials.refresh();
    }
  }

  void selectClient(Client? client) async {
    selectedClient.value = client;
  }

  void fetchAllProducts() async {
    final List<Product> allProducts = await dbHelper.getProducts();
    products.assignAll(allProducts);
  }

  // Seleccionar un serial
  void selectSerial(Serial? serial) {
    selectedSerial.value = serial;
  }

  // Guardar la factura
  Future<void> saveInvoice() async {
    // Validar que haya un producto y un serial seleccionados
    if (selectedProduct.value == null || selectedSerial.value == null) {
      Get.snackbar('Error', 'Debe seleccionar un producto y un serial.');
      return;
    }

    // Validar campos numéricos
    final parsedTotalAmount = double.tryParse(totalAmount.value) ?? 0.0;
    final parsedTotalPayed = double.tryParse(totalPayed.value) ?? 0.0;

    // Crear la factura
    final invoice = Invoice(
      documentNo: documentNo.value,
      type: type.value,
      totalAmount: parsedTotalAmount,
      totalPayed: parsedTotalPayed,
      refTotalAmount: parsedTotalAmount,
      refTotalPayed: parsedTotalPayed,
      qty: qty.value,
      clientId: clientId.value,
      bankAccountId: bankAccountId.value,
      productId: selectedProduct.value!.id!,
      createdAt: DateTime.now(),
    );

    try {
      // Guardar la factura en la base de datos
      final invoiceId = await dbHelper.insertInvoice(invoice);

      // Crear la línea de factura (InvoiceLine)
      final invoiceLine = InvoiceLine(
        productName: selectedProduct.value!.name,
        productPrice: selectedProduct.value!.price,
        refProductPrice: selectedProduct.value!.price,
        total: selectedProduct.value!.price * qty.value,
        productId: selectedProduct.value!.id!,
        productSerial: selectedSerial.value!.serial,
        invoiceId: invoiceId,
        createdAt: DateTime.now(),
      );

      // Guardar la línea de factura en la base de datos
      await dbHelper.insertInvoiceLine(invoiceLine);

      Get.snackbar('Éxito', 'Factura guardada correctamente');
      fetchAllInvoices();
      clearFields();
      Get.back();
    } catch (e) {
      Get.snackbar('Error', 'No se pudo guardar la factura: ${e.toString()}');
    }
  }

  // Limpiar campos del formulario
  void clearFields() {
    documentNo.value = '';
    type.value = '';
    totalAmount.value = '';
    totalPayed.value = '';
    qty.value = 0;
    clientId.value = 0;
    bankAccountId.value = 0;
    selectedProduct.value = null;
    selectedSerial.value = null;
    availableSerials.clear();
  }

  // Obtener todas las facturas
  void fetchAllInvoices() async {
    final List<Invoice> allInvoices = await dbHelper.getInvoices();
    invoices.assignAll(allInvoices);
    originalInvoices.assignAll(allInvoices);
  }

  // Buscar facturas
  void searchInvoices(String query) {
    searchQuery.value = query;
    applyFilters();
  }

  // Ordenar facturas
  void sortInvoices(String criteria) {
    sortCriteria.value = criteria;
    applyFilters();
  }

  // Aplicar filtros y ordenamiento
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