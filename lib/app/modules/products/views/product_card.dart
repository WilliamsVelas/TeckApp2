import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:teck_app/app/database/models/products_model.dart';
import 'package:teck_app/theme/colors.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: product.serialsQty <= product.minStock
          ? AppColors.backgroundMinStock
          : AppColors.onPrincipalBackground,
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
                  product.name,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.principalWhite),
                ),
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
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
            const SizedBox(height: 8),

            // Stock actual
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${product.minStock}',
                  style: const TextStyle(color: Colors.blue),
                ),
                Text(
                  'Stock: ${product.serialsQty}',
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
