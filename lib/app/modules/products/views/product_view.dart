import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:teck_app/app/modules/products/controllers/product_controller.dart';
import 'package:teck_app/app/modules/products/views/product_card.dart';
import 'package:teck_app/app/modules/products/views/product_form.dart';
import 'package:teck_app/app/modules/products/views/product_view.dart';
import 'package:teck_app/theme/colors.dart';

import '../../../common/generic_input.dart';

class ProductView extends StatelessWidget {
  final ProductController productController = Get.find<ProductController>();

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
                  hintText: 'Buscar producto...',
                  onChanged: (value) {
                    productController.searchProducts(value);
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
                    _showSortDialog(context, productController);
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
                        final products = productController.filteredProducts;

                        if (products.isEmpty) {
                          return const Center(
                            child: Text(
                              'No hay productos disponibles.',
                              style: TextStyle(
                                  fontSize: 16.0, color: Colors.black),
                            ),
                          );
                        }

                        return ListView.builder(
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            final product = products[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: ProductCard(product: product),
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

  void _showFiltersDialog(BuildContext context, ProductController controller) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Filtrar productos'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Filtro por estado
              DropdownButton<String>(
                value: controller.selectedStatus.value,
                onChanged: (value) {
                  controller.filterByStatus(value!);
                  Navigator.pop(context);
                },
                items: ['Activo', 'Inactivo', 'Vendido', 'Afectado']
                    .map(
                      (status) => DropdownMenuItem(
                        value: status,
                        child: Text(status),
                      ),
                    )
                    .toList(),
              ),
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

  void _showSortDialog(BuildContext context, ProductController controller) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Ordenar productos'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Fecha de creación'),
                onTap: () {
                  controller.sortProducts("date");
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Precio'),
                onTap: () {
                  controller.sortProducts("price");
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Min Stock'),
                onTap: () {
                  controller.sortProducts("stock");
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
            child: ProductForm(),
          );
        },
      );
    }
}
