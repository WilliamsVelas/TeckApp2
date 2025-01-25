import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:teck_app/app/modules/products/controllers/product_controller.dart';

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
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16.0),
          // TextField(
          //   onChanged: (value) => productController.name.value = value,
          //   decoration: const InputDecoration(labelText: 'Nombre del producto'),
          // ),
          // TextField(
          //   onChanged: (value) => productController.code.value = value,
          //   decoration: const InputDecoration(labelText: 'Código del producto'),
          // ),
          // TextField(
          //   onChanged: (value) =>
          //       productController.price.value = double.tryParse(value) ?? 0.0,
          //   decoration: const InputDecoration(labelText: 'Precio'),
          //   keyboardType: TextInputType.number,
          // ),
          // TextField(
          //   onChanged: (value) =>
          //       productController.minStock.value = int.tryParse(value) ?? 0,
          //   decoration: const InputDecoration(labelText: 'MinStock'),
          //   keyboardType: TextInputType.number,
          // ),
          // DropdownButton<int>(
          //   value: productController.providerId.value,
          //   onChanged: (value) {
          //     if (value != null) productController.providerId.value = value;
          //   },
          //   items: [
          //     DropdownMenuItem(value: 1, child: Text('Proveedor 1')),
          //     DropdownMenuItem(value: 2, child: Text('Proveedor 2')),
          //   ],
          // ),
          // DropdownButton<String>(
          //   value: productController.status.value,
          //   onChanged: (value) {
          //     if (value != null) productController.status.value = value;
          //   },
          //   items: [
          //     DropdownMenuItem(value: 'Activo', child: Text('Activo')),
          //     DropdownMenuItem(value: 'Inactivo', child: Text('Inactivo')),
          //   ],
          // ),
          const SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  productController.saveProduct();
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 12.0),
                ),
                child: const Text('Guardar'),
              ),
              const SizedBox(width: 16.0),
              ElevatedButton(
                onPressed: () {
                  productController.clearFields();
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 12.0),
                ),
                child: const Text('Borrar'),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
        ],
      ),
    );
  }
}
