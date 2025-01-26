import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:teck_app/app/modules/products/controllers/product_controller.dart';

import '../../../../theme/colors.dart';
import '../../../common/generic_input.dart';

class ProductForm extends StatelessWidget {
  final productController = Get.find<ProductController>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Agregar Producto',
            style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: AppColors.principalWhite),
          ),
          const SizedBox(height: 16.0),
          GenericFormInput(
            label: 'Nombre del producto',
            keyboardType: TextInputType.text,
            icon: Icons.production_quantity_limits,
            onChanged: (value) => productController.name.value = value,
            controller: TextEditingController()
              ..text =
                  productController.name.value, // Inicializando el controlador
          ),
          const SizedBox(height: 12.0),
          GenericFormInput(
            label: 'Código del producto',
            keyboardType: TextInputType.text,
            icon: Icons.code,
            onChanged: (value) => productController.code.value = value,
            controller: TextEditingController()
              ..text = productController.code.value,
          ),
          const SizedBox(height: 12.0),
          GenericFormInput(
            label: 'Precio',
            keyboardType: TextInputType.number,
            icon: Icons.attach_money,
            onChanged: (value) =>
                productController.price.value = double.tryParse(value) ?? 0.0,
            controller: TextEditingController()
              ..text = productController.price.value.toString(),
          ),
          const SizedBox(height: 12.0),
          GenericFormInput(
            label: 'MinStock',
            keyboardType: TextInputType.number,
            icon: Icons.store,
            onChanged: (value) =>
                productController.minStock.value = int.tryParse(value) ?? 0,
            controller: TextEditingController()
              ..text = productController.minStock.value.toString(),
          ),
          const SizedBox(height: 12.0),
          GenericFormInput(
            label: 'Select provider',
            keyboardType: TextInputType.number,
            icon: Icons.store,
            onChanged: (value) =>
            productController.minStock.value = int.tryParse(value) ?? 0,
            controller: TextEditingController()
              ..text = productController.minStock.value.toString(),
          ),
          const SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                child: ElevatedButton(
                  onPressed: () {
                    productController.saveProduct();
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.principalButton,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                  ),
                  child: const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
                    child: Text(
                      'Guardar',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: AppColors.onPrincipalBackground,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16.0),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                child: ElevatedButton(
                  onPressed: () {
                    productController.clearFields();
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.invalid,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                  ),
                  child: const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
                    child: Text(
                      'Borrar',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: AppColors.onPrincipalBackground,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
        ],
      ),
    );
  }
}
