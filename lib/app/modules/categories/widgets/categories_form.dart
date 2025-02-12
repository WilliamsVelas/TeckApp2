import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../theme/colors.dart';
import '../../../common/generic_input.dart';
import '../controllers/categories_controller.dart';

class CategoryForm extends StatelessWidget {
  final categoryController = Get.find<CategoriesController>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0), // Padding general
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Agregar Categoría',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: AppColors.principalWhite,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.0),

            GenericFormInput(
              label: 'Nombre de la categoría',
              keyboardType: TextInputType.text,
              icon: Icons.category,
              onChanged: (value) => categoryController.name.value = value,
              controller: TextEditingController()..text = categoryController.name.value,
            ),
            SizedBox(height: 16.0),

            GenericFormInput(
              label: 'Código de la categoría',
              keyboardType: TextInputType.text,
              icon: Icons.code,
              onChanged: (value) => categoryController.code?.value = value,
              controller: TextEditingController()..text = categoryController.code?.value ?? '',
            ),
            SizedBox(height: 32.0),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    categoryController.saveCategory();
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
                    categoryController.clearFields();
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
            SizedBox(height: 24.0),
          ],
        ),
      ),
    );
  }
}