import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../theme/colors.dart';
import '../../../database/models/invoice_lines_model.dart';
import '../../../database/models/invoices_model.dart';
import '../controllers/invoice_controller.dart';

class InvoiceCard extends StatelessWidget {
  final Invoice invoice;

  const InvoiceCard({Key? key, required this.invoice}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<InvoiceController>();
    RxBool isExpanded = false.obs;

    return Obx(
          () => GestureDetector(
        onTap: () => isExpanded.value = !isExpanded.value,
        child: Card(
          color: AppColors.onPrincipalBackground,
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      invoice.documentNo,
                      style: TextStyle(color: AppColors.principalWhite),
                    ),
                    Text(
                      invoice.type == "INV_P" ? "Pagada" : "Pendiente",
                      style: TextStyle(
                        color: invoice.type == "INV_P" ? Colors.green : Colors.orange,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FutureBuilder<String>(
                      future: controller.getClientName(invoice.clientId),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Text(
                            snapshot.data!,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.principalWhite,
                            ),
                          );
                        }
                        return Text('Cargando...', style: TextStyle(color: AppColors.principalGray));
                      },
                    ),
                    Text(
                      '\$${invoice.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: AppColors.principalGreen,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                if (isExpanded.value)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: Icon(Icons.receipt, color: AppColors.principalGreen),
                          onPressed: () => controller.showInvoiceDetailsModal(invoice.id!, context),
                        ),
                        if (invoice.type == 'INV_N_P') // Botón "Pagar" solo para INV_N_P
                          IconButton(
                            icon: Icon(Icons.payment, color: AppColors.principalGreen),
                            onPressed: () => controller.payInvoice(invoice.id!),
                          ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class InvoiceDetailsModal extends StatelessWidget {
  final int invoiceId;

  const InvoiceDetailsModal({required this.invoiceId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<InvoiceController>();
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Detalles',
                style: textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          Obx(() {
            if (controller.isLoadingInvoiceLines.value) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: CircularProgressIndicator(),
              );
            }
            return const SizedBox.shrink();
          }),
          Obx(() {
            if (controller.invoiceLines.isEmpty &&
                !controller.isLoadingInvoiceLines.value) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: Text('Factura sin artículos',
                    style: TextStyle(color: Colors.grey)),
              );
            }
            return const SizedBox.shrink();
          }),
          Obx(() {
            if (controller.invoiceLines.isNotEmpty) {
              return Column(
                children: [
                  Obx(() {
                    final clientId = controller.invoices
                        .firstWhere((inv) => inv.id == invoiceId)
                        .clientId;
                    return FutureBuilder<String>(
                      future: controller.getClientName(clientId),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Cliente: ${snapshot.data!}',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.principalBackground,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        }
                        return SizedBox.shrink();
                      },
                    );
                  }),
                  SizedBox(height: 20),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: controller.invoiceLines.length,
                    separatorBuilder: (_, __) => Divider(height: 20),
                    itemBuilder: (context, index) {
                      final line = controller.invoiceLines[index];
                      return InvoiceLineItem(line: line);
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'TOTAL: ',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        Obx(() => Text(
                              '\$${controller.invoiceTotal.value.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green[700],
                              ),
                            )),
                      ],
                    ),
                  )
                ],
              );
            }
            return SizedBox.shrink();
          }),
        ],
      ),
    );
  }
}

class InvoiceLineItem extends StatelessWidget {
  final InvoiceLine line;

  const InvoiceLineItem({required this.line});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                line.productName,
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.principalBackground,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '\$${line.productPrice.toStringAsFixed(2)} x (${line.qty})',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            Text(
              '\$${(line.total).toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        SizedBox(height: 4),
      ],
    );
  }
}