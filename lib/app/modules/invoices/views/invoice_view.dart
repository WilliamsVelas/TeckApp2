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
      backgroundColor: AppColors.onPrincipalBackground,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: GenericInput(
                    hintText: 'Buscar factura...',
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
              child: Obx(() {
                final invoices = controller.invoices;

                if (invoices.isEmpty) {
                  return const Center(
                    child: Text(
                      'No hay facturas disponibles.',
                      style: TextStyle(fontSize: 16.0, color: Colors.black),
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
          ),
          SizedBox(height: 16),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: ElevatedButton(
              onPressed: () {
                _openInvoiceForm(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.principalButton,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32.0),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
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
    );
  }
  void _showSortDialog(BuildContext context, InvoiceController controller) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Ordenar facturas'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Fecha de creación'),
                onTap: () {
                  controller.sortInvoices("date");
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Total'),
                onTap: () {
                  controller.sortInvoices("totalAmount");
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _openInvoiceForm(BuildContext context) {
    Get.to(() => InvoiceFormView());
  }
}

class InvoiceFormView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.onPrincipalBackground,
      appBar: AppBar(
        backgroundColor: AppColors.onPrincipalBackground,
        leading: IconButton(
          icon: const Icon(
            Icons.keyboard_arrow_left_outlined,
            color: AppColors.principalWhite,
          ),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Agregar Venta',
          style: TextStyle(color: AppColors.principalWhite),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: InvoiceForm(),
      ),
    );
  }
}