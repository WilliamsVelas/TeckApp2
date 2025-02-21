import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../theme/colors.dart';
import '../../../database/models/invoices_model.dart';
import '../controllers/invoice_controller.dart';

class InvoiceCard extends StatelessWidget {
  final Invoice invoice;

  const InvoiceCard({Key? key, required this.invoice}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final InvoiceController controller = Get.find<InvoiceController>(); // Get the controller

    return Card(
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
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.principalWhite),
                ),
                Text(
                  '\$${invoice.totalAmount}',
                  style: TextStyle(
                      color: Colors.green, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 4),
            // Client Name
            FutureBuilder<String>(
              future: controller.getClientName(invoice.clientId),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(
                    snapshot.data!,
                    style: TextStyle(color: AppColors.principalWhite),
                  );
                } else {
                  return Text('Cargando...', style: TextStyle(color: AppColors.principalGray));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
