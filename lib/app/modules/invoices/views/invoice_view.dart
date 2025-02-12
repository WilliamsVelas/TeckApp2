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
  // final InvoiceController invoiceController = Get.find<InvoiceController>();

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
                GenericInput(
                  hintText: 'Buscar factura...',
                  onChanged: (value) {
                    // productController.searchProducts(value);
                  },
                  prefixIcon: Icon(Icons.search),
                ),

                const SizedBox(width: 8),
                // IconButton(
                //   icon: const Icon(Icons.filter_list),
                //   onPressed: () {
                //     _showFiltersDialog(context, productController);
                //   },
                // ),
                IconButton(
                  icon: const Icon(Icons.sort),
                  onPressed: () {
                    // _showSortDialog(context, productController);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Column(
              children: [
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
                    child: Obx(
                          () {
                        final invoices = [];

                        if (invoices.isEmpty) {
                          return const Center(
                            child: Text(
                              'No hay ventas disponibles.',
                              style: TextStyle(
                                  fontSize: 16.0, color: Colors.black),
                            ),
                          );
                        }

                        return ListView.builder(
                          itemCount: invoices.length,
                          itemBuilder: (context, index) {
                            final invoice = invoices[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: InvoiceCard(invoice: invoice,),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: ElevatedButton(
                    onPressed: () {
                      _openProductForm(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.principalButton,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 12.0),
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
          ),
        ],
      ),
    );
  }

  void _showFiltersDialog(BuildContext context, InvoiceController controller) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Filtrar productos'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Filtro por estado
              const SizedBox(height: 8),
              // Filtro por proveedor
              // DropdownButton<int>(
              //   value: controller.selectedProvider.value,
              //   onChanged: (value) {
              //     controller.applyFilterByProvider(value!);
              //     Navigator.pop(context);
              //   },
              //   items: controller.providers.map((provider) {
              //     return DropdownMenuItem(
              //       value: provider.id,
              //       child: Text(provider.name),
              //     );
              //   }).toList(),
              // ),
            ],
          ),
        );
      },
    );
  }

  void _showSortDialog(BuildContext context, InvoiceController controller) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Ordenar ventas'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Fecha de creación'),
                onTap: () {

                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Precio'),
                onTap: () {

                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Min Stock'),
                onTap: () {

                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _openProductForm(BuildContext context) {
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
          child: InvoiceForm(),
        );
      },
    );
  }
}