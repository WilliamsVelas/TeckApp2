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
              onChanged: (value) => productController.name.value = value,
              controller: TextEditingController()..text = productController.name.value,
            ),
            SizedBox(height: 16.0),
            GenericFormInput(
              label: 'Código del producto',
              keyboardType: TextInputType.text,
              icon: Icons.code,
              onChanged: (value) => productController.code.value = value,
              controller: TextEditingController()..text = productController.code.value,
            ),
            SizedBox(height: 16.0),
            GenericFormInput(
              label: 'Precio',
              keyboardType: TextInputType.number,
              icon: Icons.attach_money,
              onChanged: (value) => productController.price.value = value,
              controller: TextEditingController()..text = productController.price.value,
            ),
            SizedBox(height: 16.0),
            GenericFormInput(
              label: 'MinStock',
              keyboardType: TextInputType.number,
              icon: Icons.store,
              onChanged: (value) => productController.minStock.value = value,
              controller: TextEditingController()..text = productController.minStock.value,
            ),
            SizedBox(height: 16.0),
            Obx(
                  () => CustomDropdown<Category>(
                hintText: 'Categoría',
                value: productController.selectedCategory.value,
                items: productController.categories,
                itemTextBuilder: (category) => category.name,
                onChanged: (category) => productController.selectCategory(category),
              ),
            ),
            SizedBox(height: 16.0),
            Obx(
                  () => CustomDropdown<Provider>(
                hintText: 'Proveedor',
                value: productController.selectedProvider.value,
                items: productController.providers,
                itemTextBuilder: (provider) => provider.name ?? '',
                onChanged: (provider) => productController.selectProvider(provider),
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Obx(
                      () => Checkbox(
                    value: productController.isSerial.value,
                    onChanged: (value) {
                      productController.isSerial.value = value ?? false;
                    },
                  ),
                ),
                Text(
                  '¿Usa seriales?',
                  style: TextStyle(color: AppColors.principalWhite),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Obx(
                  () => productController.isSerial.value
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
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: AppColors.principalWhite)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: AppColors.principalButton)),
                          ),
                          style: TextStyle(color: AppColors.principalWhite),
                          onChanged: (value) => productController.newSerial.value = value,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.add, color: AppColors.principalGreen),
                        onPressed: () => productController.addSerial(),
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
                  : GenericFormInput(
                label: 'Cantidad',
                keyboardType: TextInputType.number,
                icon: Icons.numbers,
                controller: productController.qtyController,
                onChanged: (value) {},
              ),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    productController.saveProduct();
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.principalButton,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    textStyle: TextStyle(fontSize: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: Text('Guardar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    productController.clearFields();
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.invalid,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    textStyle: TextStyle(fontSize: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
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

