import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:teck_app/app/modules/products/controllers/product_controller.dart';

import '../../../../theme/colors.dart';
import '../../../common/generic_input.dart';
import '../../../database/models/categories_model.dart';
import '../../../database/models/providers_model.dart';

class ProductForm extends StatelessWidget {
  final ProductController productController = Get.find<ProductController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.principalBackground,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GenericFormInput(
              label: 'Nombre del producto',
              keyboardType: TextInputType.text,
              icon: Icons.production_quantity_limits,
              controller: productController.nameController,
              onChanged: (value) => productController.name.value = value,
            ),
            SizedBox(height: 16.0),

            GenericFormInput(
              label: 'Código del producto',
              keyboardType: TextInputType.text,
              icon: Icons.code,
              controller: productController.codeController,
              onChanged: (value) => productController.code.value = value,
            ),
            SizedBox(height: 16.0),

            // Campo: Precio
            GenericFormInput(
              label: 'Precio',
              keyboardType: TextInputType.number,
              icon: Icons.attach_money,
              controller: productController.priceController,
              onChanged: (value) => productController.price.value = value,
            ),
            SizedBox(height: 16.0),

            // Campo: Stock mínimo
            GenericFormInput(
              label: 'MinStock',
              keyboardType: TextInputType.number,
              icon: Icons.store,
              controller: productController.minStockController,
              onChanged: (value) => productController.minStock.value = value,
            ),
            SizedBox(height: 16.0),

            // Selector: Categoría
            Obx(
                  () => CustomDropdown<Category>(
                hintText: 'Categoría',
                value: productController.selectedCategory.value,
                items: productController.categories,
                itemTextBuilder: (category) => category.name,
                onChanged: productController.selectCategory,
              ),
            ),
            SizedBox(height: 16.0),

            // Selector: Proveedor
            Obx(
                  () => CustomDropdown<Provider>(
                hintText: 'Proveedor',
                value: productController.selectedProvider.value,
                items: productController.providers,
                itemTextBuilder: (provider) => provider.name ?? '',
                onChanged: productController.selectProvider,
              ),
            ),
            SizedBox(height: 16.0),

            // Checkbox: ¿Usa seriales?
            if (productController.editingProductId.value.isEmpty)
              Row(
                children: [
                  Obx(
                        () => Checkbox(
                      value: productController.isSerial.value,
                      onChanged: (value) => productController.isSerial.value = value ?? false,
                    ),
                  ),
                  Text(
                    '¿Usa seriales?',
                    style: TextStyle(color: AppColors.principalWhite),
                  ),
                ],
              ),
            SizedBox(height: 16.0),

            // Sección de seriales
            Obx(
                  () => (!productController.editingProductId.value.isNotEmpty && productController.isSerial.value)
                  ? Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: productController.newSerialController,
                          decoration: InputDecoration(
                            labelText: 'Serial',
                            labelStyle: TextStyle(color: AppColors.principalWhite),
                          ),
                          onChanged: (value) => productController.newSerial.value = value,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.add, color: AppColors.principalGreen),
                        onPressed: productController.addSerial,
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: 100),
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: productController.serials.length,
                      separatorBuilder: (context, index) => Divider(color: AppColors.principalGray),
                      itemBuilder: (context, index) {
                        final serial = productController.serials[index];
                        return ListTile(
                          title: Text(serial, style: TextStyle(color: AppColors.principalWhite)),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: AppColors.invalid),
                            onPressed: () => productController.removeSerial(index),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              )
                  : SizedBox.shrink(),
            ),

            // Campo: Cantidad (si no usa seriales)
            Obx(
                  () => !productController.isSerial.value
                  ? GenericFormInput(
                label: 'Cantidad',
                keyboardType: TextInputType.number,
                icon: Icons.numbers,
                controller: productController.qtyController,
                onChanged: (value) => productController.serialsQty.value = int.tryParse(value) ?? 0, // Actualiza serialsQty
              )
                  : SizedBox.shrink(),
            ),
            Spacer(),

            // Botones: Guardar y Borrar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: productController.saveProduct,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.principalButton,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                  child: Text('Guardar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    productController.clearFields();
                    Get.back(); // Asumiendo que quieres cerrar el formulario al borrar
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.invalid,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                  child: Text('Borrar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}