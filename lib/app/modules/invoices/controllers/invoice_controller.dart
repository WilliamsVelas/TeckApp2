import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../theme/colors.dart';
import '../../../common/custom_snakcbar.dart';
import '../../../database/database_helper.dart';
import '../../../database/models/clients_model.dart';
import '../../../database/models/invoice_lines_model.dart';
import '../../../database/models/invoices_model.dart';
import '../../../database/models/products_model.dart';
import '../../../database/models/serials_model.dart';
import '../widgets/invoice_card.dart';

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

  final RxBool isLoadingInvoiceLines = false.obs;
  final RxDouble invoiceTotal = 0.0.obs;

  final RxString documentNo = ''.obs;
  final RxString totalPayed = ''.obs;
  final RxString type = ''.obs;

  final RxInt selectedQty = 1.obs;

  final RxBool showUnpaidOnly = false.obs;

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
    return '${client?.name} ${client?.lastName}';
  }

  Future<void> fetchAllProducts() async {
    final List<Product> allProducts = await dbHelper.getProducts();
    products.assignAll(allProducts);
  }

  void selectProduct(Product? product) async {
    selectedProduct.value = product;
    availableSerials.clear();
    selectedSerial.value = null;
    selectedQty.value = 1;
    if (product != null) {
      final List<Serial> serials = await dbHelper.getSerialsByProductId(product.id!);
      availableSerials.assignAll(serials.where((serial) => serial.status == 'activo'));
    }
  }

  void selectClient(Client? client) {
    selectedClient.value = client;
  }

  void selectSerial(Serial? serial) {
    selectedSerial.value = serial;
  }

  void addInvoiceLine() {
    if (selectedProduct.value == null) {
      CustomSnackbar.show(
        title: "¡Ocurrió un error!",
        message: "Debe seleccionar un producto.",
        icon: Icons.cancel,
        backgroundColor: AppColors.invalid,
      );
      return;
    }

    final product = selectedProduct.value!;
    final hasSerials = availableSerials.isNotEmpty;

    if (hasSerials) {
      if (selectedSerial.value == null) {
        CustomSnackbar.show(
          title: "¡Ocurrió un error!",
          message: "Debe seleccionar un serial",
          icon: Icons.cancel,
          backgroundColor: AppColors.invalid,
        );
        return;
      }

      final invoiceLine = InvoiceLine(
        productName: product.name,
        productPrice: product.price,
        refProductPrice: product.price,
        total: product.price,
        qty: 1,
        productId: product.id!,
        productSerial: selectedSerial.value!.serial,
        invoiceId: 0,
        createdAt: DateTime.now(),
      );

      invoiceLines.add(invoiceLine);
      availableSerials.remove(selectedSerial.value);
      selectedSerial.value = null;
    } else {
      if (selectedQty.value <= 0 || selectedQty.value > product.serialsQty) {
        CustomSnackbar.show(
          title: "¡Ocurrió un error!",
          message: "Cantidad inválida o excede el stock disponible.",
          icon: Icons.cancel,
          backgroundColor: AppColors.invalid,
        );
        return;
      }

      final invoiceLine = InvoiceLine(
        productName: product.name,
        productPrice: product.price,
        refProductPrice: product.price,
        total: product.price * selectedQty.value,
        qty: selectedQty.value,
        productId: product.id!,
        productSerial: '',
        invoiceId: 0,
        createdAt: DateTime.now(),
      );

      invoiceLines.add(invoiceLine);
      selectedQty.value = 1;
    }

    selectedProduct.value = null;
    selectedSerial.value = null;
    availableSerials.clear();
    invoiceTotal.value = calculateTotalAmount();
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
      CustomSnackbar.show(
        title: "¡Ocurrió un error!",
        message: "Debe agregar al menos una línea de factura.",
        icon: Icons.cancel,
        backgroundColor: AppColors.invalid,
      );
      return;
    }
    if (selectedClient.value == null) {
      CustomSnackbar.show(
        title: "¡Ocurrió un error!",
        message: "Debe seleccionar un cliente.",
        icon: Icons.cancel,
        backgroundColor: AppColors.invalid,
      );
      return;
    }
    if (documentNo.value.isEmpty) {
      CustomSnackbar.show(
        title: "¡Ocurrió un error!",
        message: "El número de documento es obligatorio.",
        icon: Icons.cancel,
        backgroundColor: AppColors.invalid,
      );
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
          qty: line.qty,
          productId: line.productId,
          productSerial: line.productSerial,
          invoiceId: invoiceId,
          createdAt: line.createdAt,
        );
        await dbHelper.insertInvoiceLine(updatedLine);

        final product = await dbHelper.getProductById(line.productId);
        if (line.productSerial.isNotEmpty) {
          final serial = (await dbHelper.getSerialsByProductId(product!.id!))
              .firstWhere((s) => s.serial == line.productSerial);
          serial.status = 'usado';
          await dbHelper.updateSerial(serial);
        } else {
          product!.serialsQty -= line.qty;
          await dbHelper.updateProduct(product);
        }
      }
      Get.back();
      clearFields();
      fetchAllInvoices();
      CustomSnackbar.show(
        title: "¡Aprobado!",
        message: "Factura guardada correctamente",
        icon: Icons.check_circle,
        backgroundColor: AppColors.principalGreen,
      );
    } catch (e) {
      CustomSnackbar.show(
        title: "¡Ocurrió un error!",
        message: "Verifique los datos e intente nuevamente.",
        icon: Icons.cancel,
        backgroundColor: AppColors.invalid,
      );
    }
  }

  Future<void> payInvoice(int invoiceId) async {
    try {
      final invoice = invoices.firstWhere((inv) => inv.id == invoiceId);
      invoice.type = 'INV_P';
      invoice.totalPayed = invoice.totalAmount;
      invoice.updatedAt = DateTime.now();

      await dbHelper.updateInvoice(invoice);
      fetchAllInvoices();
      CustomSnackbar.show(
        title: "¡Aprobado!",
        message: "Factura pagada correctamente",
        icon: Icons.check_circle,
        backgroundColor: AppColors.principalGreen,
      );
    } catch (e) {
      CustomSnackbar.show(
        title: "¡Ocurrió un error!",
        message: "No se pudo pagar la factura: $e",
        icon: Icons.cancel,
        backgroundColor: AppColors.invalid,
      );
    }
  }

  void clearFields() {
    documentNo.value = '';
    totalPayed.value = '';
    type.value = '';
    selectedClient.value = null;
    selectedProduct.value = null;
    selectedSerial.value = null;
    invoiceLines.clear();
    availableSerials.clear();
    clients.clear();
    products.clear();
    selectedQty.value = 1;
    invoiceTotal.value = 0.0;
  }

  Future<void> fetchAllInvoices() async {
    final List<Invoice> allInvoices = await dbHelper.getInvoices();
    invoices.assignAll(allInvoices);
    originalInvoices.assignAll(allInvoices);
    applyFilters();
  }

  void searchInvoices(String query) {
    searchQuery.value = query;
    applyFilters();
  }

  void sortInvoices(String criteria) {
    sortCriteria.value = criteria;
    applyFilters();
  }

  void toggleUnpaidFilter(bool value) {
    showUnpaidOnly.value = value;
    applyFilters();
  }

  void applyFilters() {
    var filtered = originalInvoices.where((invoice) {
      final matchesSearch = searchQuery.isEmpty ||
          invoice.documentNo.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          invoice.type.toLowerCase().contains(searchQuery.value.toLowerCase());
      final matchesUnpaid = !showUnpaidOnly.value || invoice.type == 'INV_N_P';
      return matchesSearch && matchesUnpaid;
    }).toList();

    if (sortCriteria.value == 'date') {
      filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } else if (sortCriteria.value == 'totalAmount') {
      filtered.sort((a, b) => a.totalAmount.compareTo(b.totalAmount));
    }

    invoices.value = filtered;
  }

  Future<void> loadInvoiceLines(int invoiceId) async {
    try {
      isLoadingInvoiceLines.value = true;
      final lines = await dbHelper.getInvoiceLinesByInvoiceId(invoiceId);
      invoiceLines.assignAll(lines);
      invoiceTotal.value = calculateTotalAmount();
    } catch (e) {
      print('Error cargando líneas de factura: $e');
    } finally {
      isLoadingInvoiceLines.value = false;
    }
  }

  void showInvoiceDetailsModal(int invoiceId, BuildContext context) {
    loadInvoiceLines(invoiceId);
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.principalBackground,
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.5,
      ),
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
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Venta',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.principalWhite)),
                  IconButton(
                    icon: Icon(Icons.close, color: AppColors.principalGray),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.principalWhite,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InvoiceDetailsModal(invoiceId: invoiceId),
              ),
            ],
          ),
        );
      },
    );
  }
}