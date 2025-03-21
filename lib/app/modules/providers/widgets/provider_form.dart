import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../theme/colors.dart';
import '../../../common/generic_input.dart';
import '../../../utils/input_validations.dart';
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
              controller: TextEditingController()
                ..text = providerController.name.value,
              inputFormatters: InputFormatters.textOnly(),
            ),
            SizedBox(height: 16.0),
            GenericFormInput(
              label: 'Apellido',
              keyboardType: TextInputType.text,
              icon: Icons.person,
              onChanged: (value) => providerController.lastName.value = value,
              controller: TextEditingController()
                ..text = providerController.lastName.value,
              inputFormatters: InputFormatters.textOnly(),
            ),
            SizedBox(height: 16.0),
            GenericFormInput(
              label: 'Razón Social',
              keyboardType: TextInputType.text,
              icon: Icons.business,
              onChanged: (value) =>
                  providerController.businessName.value = value,
              controller: TextEditingController()
                ..text = providerController.businessName.value,
              inputFormatters: InputFormatters.textOnly(),
            ),
            SizedBox(height: 16.0),
            GenericFormInput(
              label: 'C.I / RIF',
              keyboardType: TextInputType.text,
              icon: Icons.perm_identity,
              onChanged: (value) => providerController.value.value = value,
              controller: TextEditingController()
                ..text = providerController.value.value,
              inputFormatters: InputFormatters.value(),
            ),
            SizedBox(height: 16.0),
            GenericFormInput(
              label: 'Numero telefonico',
              keyboardType: TextInputType.number,
              icon: Icons.phone,
              onChanged: (value) =>
                  providerController.phoneNumber.value = value,
              controller: TextEditingController()
                ..text = providerController.phoneNumber.value,
              inputFormatters: InputFormatters.numericCode(maxLength: 11),
            ),
            SizedBox(height: 16.0),
            GenericFormInput(
              label: 'Numero telefonico',
              keyboardType: TextInputType.text,
              icon: Icons.map,
              onChanged: (value) => providerController.address.value = value,
              controller: TextEditingController()
                ..text = providerController.address.value,
              inputFormatters: InputFormatters.textOnly(),
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
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
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
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
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
