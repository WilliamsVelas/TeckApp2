import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:teck_app/app/modules/invoices/controllers/invoice_controller.dart';
import 'package:teck_app/app/modules/invoices/widgets/invoice_card.dart';

import '../../../../theme/colors.dart';
import '../../../common/generic_input.dart';
import '../widgets/invoice_form.dart';

class InvoiceView extends StatelessWidget {
  final InvoiceController controller = Get.find<InvoiceController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.onPrincipalBackground,
          title: Text(
            'Ventas',
            style: TextStyle(color: AppColors.principalWhite),
          ),
        ),
        backgroundColor: AppColors.onPrincipalBackground,
        body: RefreshIndicator(
          onRefresh: () async {
            controller.fetchAll();
          },
          color: AppColors.principalGreen,
          backgroundColor: AppColors.onPrincipalBackground,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: GenericInput(
                            hintText: 'Buscar venta...',
                            onChanged: (value) {
                              controller.searchInvoices(value);
                            },
                            prefixIcon: const Icon(Icons.search),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.sort),
                          onPressed: () {
                            _showSortDialog(context, controller);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.filter_alt),
                          onPressed: () {
                            _showFilterDialog(context, controller);
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: const BoxDecoration(
                    color: AppColors.principalBackground,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(32.0),
                      bottom: Radius.circular(32.0),
                    ),
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ventas',
                        style: TextStyle(
                            fontSize: 18.0,
                            color: AppColors.principalWhite,
                            fontWeight: FontWeight.bold),
                      ),
                      Obx(
                        () => Text(
                          '${controller.invoices.length} ventas',
                          style: TextStyle(
                              fontSize: 12.0, color: AppColors.principalGray),
                        ),
                      ),
                      Expanded(
                        child: Obx(() {
                          final invoices = controller.invoices;

                          if (invoices.isEmpty) {
                            return const Center(
                              child: Text(
                                'No hay ventas disponibles.',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    color: AppColors.principalGray),
                              ),
                            );
                          }

                          return ListView.builder(
                            itemCount: invoices.length,
                            itemBuilder: (context, index) {
                              final invoice = invoices[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: InvoiceCard(invoice: invoice),
                              );
                            },
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: ElevatedButton(
                  onPressed: () {
                    controller.fetchAll();
                    _openInvoiceForm(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.principalButton,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                  ),
                  child: const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                    child: Text(
                      'Agregar',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: AppColors.onPrincipalBackground,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
            ],
          ),
        ));
  }

  void _showSortDialog(BuildContext context, InvoiceController controller) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.principalBackground,
          title: Text(
            'Ordenar ventas',
            style: TextStyle(color: AppColors.principalWhite),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildSortOption(
                context,
                title: 'Fecha de creación',
                onTap: () {
                  controller.sortInvoices("date");
                  Navigator.pop(context);
                },
              ),
              SizedBox(height: 8.0),
              _buildSortOption(
                context,
                title: 'Total',
                onTap: () {
                  controller.sortInvoices("totalAmount");
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancelar',
                style: TextStyle(color: AppColors.principalWhite),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSortOption(BuildContext context,
      {required String title, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        margin: EdgeInsets.only(bottom: 8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                color: AppColors.principalGray,
                fontSize: 14,
              ),
            ),
            Icon(
              Icons.sort,
              color: AppColors.principalGray,
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterDialog(BuildContext context, InvoiceController controller) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.principalBackground,
          title: Text(
            'Filtrar ventas',
            style: TextStyle(color: AppColors.principalWhite),
          ),
          content: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.8,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () => _buildFilterSwitch(
                    title: 'Mostrar pagos pendientes.',
                    value: controller.showUnpaidOnly.value,
                    onChanged: (value) => controller.toggleUnpaidFilter(value),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancelar',
                style: TextStyle(color: AppColors.principalWhite),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFilterSwitch({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.principalGreen,
            inactiveThumbColor: AppColors.principalGray,
            inactiveTrackColor: Colors.grey[300],
          ),
          Flexible(
            child: Text(
              title,
              style: TextStyle(
                color: AppColors.principalGray,
                fontSize: 12,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  void _openInvoiceForm(BuildContext context) {
    controller.setNextDocumentNo();
    Get.to(() => InvoiceFormView());
  }
}

class InvoiceFormView extends StatelessWidget {
  final bool isPaymentMode;

  InvoiceFormView({this.isPaymentMode = false});

  @override
  Widget build(BuildContext context) {
    final InvoiceController controller = Get.find<InvoiceController>();

    if (!isPaymentMode) {
      controller.clearFields();
      controller.setNextDocumentNo();
      controller.fetchAll();
    }

    return WillPopScope(
      onWillPop: () async {
        controller.clearFields();
        return true;
      },
      child: Scaffold(
        backgroundColor: AppColors.onPrincipalBackground,
        appBar: AppBar(
          backgroundColor: AppColors.onPrincipalBackground,
          leading: IconButton(
            icon: const Icon(
              Icons.keyboard_arrow_left_outlined,
              color: AppColors.principalWhite,
            ),
            onPressed: () {
              controller.clearFields();
              Get.back();
            },
          ),
          title: Text(
            isPaymentMode ? 'Pagar Venta' : 'Agregar Venta',
            style: TextStyle(color: AppColors.principalWhite),
          ),
        ),
        body: Obx(
              () {
            if (controller.clients.isEmpty || controller.products.isEmpty || controller.paymentMethods.isEmpty) {
              return Center(
                child: CircularProgressIndicator(
                  color: AppColors.principalWhite,
                ),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: InvoiceForm(isPaymentMode: isPaymentMode),
              );
            }
          },
        ),
      ),
    );
  }
}
