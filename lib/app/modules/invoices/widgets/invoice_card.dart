import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../theme/colors.dart';
import '../../../database/models/invoices_model.dart';

class InvoiceCard extends StatelessWidget {
  final Invoice invoice;

  const InvoiceCard({Key? key, required this.invoice}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                  invoice.qty.toString(),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Nombre del provider',
                  style: TextStyle(color: AppColors.principalWhite),
                ),
              ],
            ),
            const SizedBox(height: 4),

            // Stock actual
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Stock: ${invoice.refTotalAmount}',
                  style: const TextStyle(color: AppColors.principalGray),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
