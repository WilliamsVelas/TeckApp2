import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:teck_app/app/modules/products/controllers/product_controller.dart';
import 'package:teck_app/app/modules/products/views/product_card.dart';
import 'package:teck_app/app/modules/products/views/product_form.dart';
import 'package:teck_app/theme/colors.dart';

import '../../../common/custom_snakcbar.dart';
import '../../../common/generic_input.dart';
import '../../../database/models/categories_model.dart';
import '../../home/views/home_view.dart';

class ProductView extends StatelessWidget {
  final ProductController controller = Get.find<ProductController>();

  @override
  Widget build(BuildContext context) {
    controller.clearLists();
    controller.fetchAll();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.onPrincipalBackground,
        title: Text(
          'Inventario',
          style: TextStyle(color: AppColors.principalWhite),
        ),
      ),
      backgroundColor: AppColors.onPrincipalBackground,
      body: RefreshIndicator(
        onRefresh: () async {
          controller.fetchAllProducts();
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: GenericInput(
                      hintText: 'Buscar producto...',
                      onChanged: (value) {
                        controller.searchProducts(value);
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
                      _showFiltersDialog(context, controller);
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Inventario',
                      style: TextStyle(
                          fontSize: 18.0,
                          color: AppColors.principalWhite,
                          fontWeight: FontWeight.bold),
                    ),
                    Obx(
                      () => Text(
                        '${controller.products.length} productos',
                        style: TextStyle(
                            fontSize: 12.0, color: AppColors.principalGray),
                      ),
                    ),
                    Expanded(
                      child: Obx(() {
                        final products = controller.products;

                        if (products.isEmpty) {
                          return const Center(
                            child: Text(
                              'No hay productos disponibles.',
                              style: TextStyle(
                                  fontSize: 16.0,
                                  color: AppColors.principalGray),
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
                  _openProductForm(context);
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
                    'Agregar producto',
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
    );
  }

  void _showFiltersDialog(BuildContext context, ProductController controller) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.principalBackground,
          title: Text(
            'Filtrar productos',
            style: TextStyle(color: AppColors.principalWhite),
          ),
          content: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.8,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Obx(
                  () => _buildStatusDropdown(
                    value: controller.selectedStatus.value.isEmpty
                        ? null
                        : controller.selectedStatus.value,
                    onChanged: (value) => controller.filterByStatus(value),
                  ),
                ),
                SizedBox(height: 16.0),
                Obx(
                  () => _buildCategoryDropdown(
                    value: controller.selectedCategoryId.value == 0
                        ? null
                        : controller.selectedCategoryId.value,
                    categories: controller.categories,
                    onChanged: (value) => controller.filterByCategory(value),
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
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.principalButton,
              ),
              child: Text(
                'Aplicar',
                style: TextStyle(color: AppColors.onPrincipalBackground),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatusDropdown({
    required String? value,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: DropdownButton<String?>(
        value: value,
        hint: Text(
          "Seleccionar Estado",
          style: TextStyle(color: AppColors.principalGray),
        ),
        onChanged: onChanged,
        items: [
          DropdownMenuItem<String?>(
            value: null,
            child: Text(
              'Todos los estados',
              style: TextStyle(color: AppColors.principalGray),
            ),
          ),
          ...['Activo', 'Inactivo'].map(
            (status) => DropdownMenuItem<String>(
              value: status,
              child: Text(
                status,
                style: TextStyle(color: AppColors.principalGray),
              ),
            ),
          ),
        ],
        isExpanded: true,
        underline: SizedBox(),
        icon: Icon(Icons.arrow_drop_down, color: AppColors.principalGray),
      ),
    );
  }

  Widget _buildCategoryDropdown({
    required int? value,
    required List<Category> categories,
    required ValueChanged<int?> onChanged,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: DropdownButton<int?>(
        value: value,
        hint: Text(
          "Seleccionar Categoría",
          style: TextStyle(color: AppColors.principalGray),
        ),
        onChanged: onChanged,
        items: [
          DropdownMenuItem<int?>(
            value: null,
            child: Text(
              'Todas las categorías',
              style: TextStyle(color: AppColors.principalGray),
            ),
          ),
          ...categories.map(
            (category) => DropdownMenuItem<int>(
              value: category.id,
              child: Text(
                category.name,
                style: TextStyle(color: AppColors.principalGray),
              ),
            ),
          ),
        ],
        isExpanded: true,
        underline: SizedBox(),
        icon: Icon(Icons.arrow_drop_down, color: AppColors.principalGray),
      ),
    );
  }

  void _showSortDialog(BuildContext context, ProductController controller) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.principalBackground,
          title: Text(
            'Ordenar',
            style: TextStyle(color: AppColors.principalWhite),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildSortOption(
                context,
                title: 'Fecha de creación',
                onTap: () {
                  controller.sortProducts("date");
                  Navigator.pop(context);
                },
              ),
              SizedBox(height: 8.0),
              _buildSortOption(
                context,
                title: 'Precio',
                onTap: () {
                  controller.sortProducts("price");
                  Navigator.pop(context);
                },
              ),
              SizedBox(height: 8.0),
              _buildSortOption(
                context,
                title: 'Min Stock',
                onTap: () {
                  controller.sortProducts("stock");
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

  void _openProductForm(BuildContext context) {
    controller.clearFields();
    if (controller.categories.isEmpty || controller.providers.isEmpty) {
      CustomSnackbar.show(
        title: "¡Ocurrió un error!",
        message: "Guarde proveedores y categorias para continuar.",
        icon: Icons.cancel,
        backgroundColor: AppColors.invalid,
      );
    }
    Get.to(() => ProductFormView());
  }
}

class ProductFormView extends StatelessWidget {
  final ProductController productController = Get.find<ProductController>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        productController.clearFields();
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
              productController.clearFields();
              Get.back();
            },
          ),
          title: Text(
            'Agregar Producto',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: AppColors.principalWhite,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        body: FutureBuilder<bool>(
          future: productController.hasCategoriesAndProviders(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: AppColors.principalWhite,
                ),
              );
            }

            if (!snapshot.hasData || !snapshot.data!) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Get.back();
                CustomSnackbar.show(
                  title: "¡Error!",
                  message: "Debe haber al menos una categoría y un proveedor.",
                  icon: Icons.error,
                  backgroundColor: AppColors.invalid,
                );
              });

              return Center(
                child: Text(
                  "No hay categorías o proveedores disponibles.",
                  style: TextStyle(color: AppColors.principalWhite),
                ),
              );
            }

            return ProductForm();
          },
        ),
      ),
    );
  }
}
