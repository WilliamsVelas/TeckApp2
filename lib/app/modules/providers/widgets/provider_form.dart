import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../theme/colors.dart';
import '../../../common/generic_input.dart';
import '../controllers/provider_controller.dart';

class ProviderForm extends StatelessWidget {
  final providerController = Get.find<ProviderController>();

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
              'Agregar Proveedor',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: AppColors.principalWhite,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.0),

            GenericFormInput(
              label: 'Nombre',
              keyboardType: TextInputType.text,
              icon: Icons.person,
              onChanged: (value) => providerController.name.value = value,
              controller: TextEditingController()..text = providerController.name.value,
            ),
            SizedBox(height: 16.0),

            GenericFormInput(
              label: 'Apellido',
              keyboardType: TextInputType.text,
              icon: Icons.person,
              onChanged: (value) => providerController.lastName.value = value,
              controller: TextEditingController()..text = providerController.lastName.value,
            ),
            SizedBox(height: 16.0),

            GenericFormInput(
              label: 'Razón Social',
              keyboardType: TextInputType.text,
              icon: Icons.business,
              onChanged: (value) => providerController.businessName.value = value,
              controller: TextEditingController()..text = providerController.businessName.value,
            ),
            SizedBox(height: 16.0),

            GenericFormInput(
              label: 'Value',
              keyboardType: TextInputType.text,
              icon: Icons.attach_money,
              onChanged: (value) => providerController.value.value = value,
              controller: TextEditingController()..text = providerController.value.value,
            ),

            SizedBox(height: 32.0),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    providerController.saveProvider();
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
                    providerController.clearFields();
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