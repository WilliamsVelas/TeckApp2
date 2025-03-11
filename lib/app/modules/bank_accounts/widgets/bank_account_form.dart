import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../theme/colors.dart';
import '../../../common/generic_input.dart';
import '../../../database/models/clients_model.dart';
import '../controller/bank_account_controller.dart';

class BankAccountForm extends StatelessWidget {
  final bankAccountController = Get.find<BankAccountController>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Agregar Cuenta Bancaria',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: AppColors.principalWhite,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.0),
            GenericFormInput(
              label: 'Nombre del Banco',
              keyboardType: TextInputType.text,
              icon: Icons.account_balance,
              onChanged: (value) =>
                  bankAccountController.bankName.value = value,
              controller: TextEditingController()
                ..text = bankAccountController.bankName.value,
            ),
            SizedBox(height: 16.0),
            GenericFormInput(
              label: 'Código',
              keyboardType: TextInputType.text,
              icon: Icons.code,
              onChanged: (value) => bankAccountController.code.value = value,
              controller: TextEditingController()
                ..text = bankAccountController.code.value,
            ),
            SizedBox(height: 16.0),
            GenericFormInput(
              label: 'Número de Cuenta',
              keyboardType: TextInputType.number,
              icon: Icons.credit_card,
              onChanged: (value) =>
                  bankAccountController.numberAccount.value = value,
              controller: TextEditingController()
                ..text = bankAccountController.numberAccount.value,
            ),
            SizedBox(height: 16.0),
            Obx(
              () => CustomDropdown<Client>(
                hintText: 'Cliente',
                value: bankAccountController.selectedClient.value,
                items: bankAccountController.clients,
                itemTextBuilder: (client) => client.businessName,
                onChanged: (client) =>
                    bankAccountController.selectClient(client),
              ),
            ),
            SizedBox(height: 32.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    bankAccountController.saveBankAccount();
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
                    bankAccountController.clearFields();
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
          ],
        ),
      ),
    );
  }
}
