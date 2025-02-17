import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:teck_app/app/database/models/products_model.dart';
import 'package:teck_app/theme/colors.dart';

import '../controllers/product_controller.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProductController controller = Get.find<ProductController>();

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
            // Provider Name
            FutureBuilder<String>(
              future: controller.getProviderName(product.providerId),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(
                    snapshot.data!,
                    style: TextStyle(color: AppColors.principalWhite),
                  );
                } else {
                  return Text('Cargando...',
                      style: TextStyle(color: AppColors.principalGray));
                }
              },
            ),
            SizedBox(height: 4),
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
            SizedBox(height: 4),
            // Stock actual
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FutureBuilder<String>(
                  future: controller.getCategoryName(product.categoryId),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text(
                        snapshot.data!,
                        style: TextStyle(color: AppColors.principalWhite),
                      );
                    } else {
                      return Text('Cargando...',
                          style: TextStyle(color: AppColors.principalGray));
                    }
                  },
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
