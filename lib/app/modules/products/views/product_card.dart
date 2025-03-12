import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:teck_app/app/database/models/products_model.dart';
import 'package:teck_app/theme/colors.dart';

import '../../../database/models/serials_model.dart';
import '../controllers/product_controller.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProductController controller = Get.find<ProductController>();
    RxBool isExpanded = false.obs;

    return Obx(
      () => GestureDetector(
        onTap: () => isExpanded.value = !isExpanded.value,
        child: Card(
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
                    // Provider Name
                    FutureBuilder<String>(
                      future: controller.getProviderName(product.providerId),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Text(
                            snapshot.data!,
                            style: TextStyle(color: AppColors.principalWhite, fontWeight: FontWeight.normal),
                          );
                        } else {
                          return Text('Cargando...',
                              style: TextStyle(color: AppColors.principalGray));
                        }
                      },
                    ),
                    Text(
                      product.isActive ? 'Activo' : 'Inactivo',
                      style: TextStyle(
                        fontSize: 12,
                        color: product.isActive ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
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
                        color: AppColors.principalWhite,
                      ),
                    ),
                    Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FutureBuilder<String>(
                      future: controller.getCategoryName(product.categoryId),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Text(
                            snapshot.data!,
                            style: TextStyle(color: AppColors.principalGray, fontWeight: FontWeight.normal),
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
                if (isExpanded.value)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.list,
                            color: AppColors.principalButton,
                          ),
                          onPressed: product.isActive
                              ? () {
                            controller.showSerialsProductModal(product.id!, context);
                            isExpanded.value = false;
                          }
                              : null,
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: AppColors.warning,
                          ),
                          onPressed: product.isActive
                              ? () {
                                  controller.editProduct(product);
                                  isExpanded.value = false;
                                }
                              : null,
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: AppColors.invalid,
                          ),
                          onPressed: product.isActive
                              ? () {
                                  controller.deactivateProduct(product.id!);
                                  isExpanded.value = false;
                                }
                              : null,
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

class SerialsModal extends StatelessWidget {
  final int productId;

  const SerialsModal({required this.productId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductController>();

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Seriales del Producto',
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
          Obx(() {
            if (controller.isLoadingSerials.value) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child:
                    CircularProgressIndicator(color: AppColors.principalGreen),
              );
            }

            if (controller.productSerials.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: Text('No hay seriales registrados para este producto',
                    style: TextStyle(color: AppColors.principalGray)),
              );
            }

            return ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: controller.productSerials.length,
              separatorBuilder: (_, __) => SizedBox(height: 12),
              itemBuilder: (context, index) {
                final serial = controller.productSerials[index];
                return SerialCard(serial: serial);
              },
            );
          }),
        ],
      ),
    );
  }
}

class SerialCard extends StatelessWidget {
  final Serial serial;

  const SerialCard({Key? key, required this.serial}) : super(key: key);

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
                  serial.serial,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.principalWhite,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(serial.status),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    serial.status.toUpperCase(),
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.principalWhite,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              'Registrado: ${DateFormat('dd/MM/yyyy').format(DateTime.fromMillisecondsSinceEpoch(serial.createdAt))}',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.principalGray,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'activo':
        return AppColors.principalGreen;
      case 'usado':
        return Colors.orange;
      case 'desactivado':
        return AppColors.invalid;
      default:
        return AppColors.principalGray;
    }
  }
}
