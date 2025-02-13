import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../theme/colors.dart';
import '../../../common/generic_input.dart';
import '../controllers/clients_controller.dart';

class ClientForm extends StatelessWidget {
  final clientController = Get.find<ClientsController>();

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
              'Agregar Cliente',
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
              onChanged: (value) => clientController.name.value = value,
              controller: TextEditingController()
                ..text = clientController.name.value,
            ),
            SizedBox(height: 16.0),
            GenericFormInput(
              label: 'Apellido',
              keyboardType: TextInputType.text,
              icon: Icons.person,
              onChanged: (value) => clientController.lastName.value = value,
              controller: TextEditingController()
                ..text = clientController.lastName.value,
            ),
            SizedBox(height: 16.0),
            GenericFormInput(
              label: 'Razón Social',
              keyboardType: TextInputType.text,
              icon: Icons.business,
              onChanged: (value) => clientController.businessName.value = value,
              controller: TextEditingController()
                ..text = clientController.businessName.value,
            ),
            SizedBox(height: 16.0),
            GenericFormInput(
              label: 'Cuenta Bancaria',
              keyboardType: TextInputType.text,
              icon: Icons.account_balance,
              onChanged: (value) => clientController.bankAccount.value = value,
              controller: TextEditingController()
                ..text = clientController.bankAccount.value,
            ),
            SizedBox(height: 16.0),
            GenericFormInput(
              label: 'Código del Banco',
              keyboardType: TextInputType.text,
              icon: Icons.account_balance,
              onChanged: (value) => clientController.codeBank.value = value,
              controller: TextEditingController()
                ..text = clientController.codeBank.value,
            ),
            SizedBox(height: 16.0),
            GenericFormInput(
              label: 'Código de Afiliado',
              keyboardType: TextInputType.text,
              icon: Icons.confirmation_number,
              onChanged: (value) =>
                  clientController.affiliateCode.value = value,
              controller: TextEditingController()
                ..text = clientController.affiliateCode.value,
            ),
            SizedBox(height: 16.0),
            GenericFormInput(
              label: 'Value',
              keyboardType: TextInputType.text,
              icon: Icons.attach_money,
              onChanged: (value) => clientController.value.value = value,
              controller: TextEditingController()
                ..text = clientController.value.value,
            ),
            SizedBox(height: 32.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    clientController.saveClient();
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
                    clientController.clearFields();
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
