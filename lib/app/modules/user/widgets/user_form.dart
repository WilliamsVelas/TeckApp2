import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../theme/colors.dart';
import '../../../common/generic_input.dart';
import '../controllers/user_controller.dart';

class UserForm extends StatelessWidget {
  final UserController controller = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GenericFormInput(
              label: 'Nombre',
              keyboardType: TextInputType.text,
              icon: Icons.person,
              controller: controller.nameController,
              onChanged: (value) => controller.nameController.text = value,
            ),
            SizedBox(height: 16.0),
            GenericFormInput(
              label: 'Apellido',
              keyboardType: TextInputType.text,
              icon: Icons.person_outline,
              controller: controller.lastNameController,
              onChanged: (value) => controller.lastNameController.text = value,
            ),
            SizedBox(height: 16.0),
            GenericFormInput(
              label: 'Nombre de usuario',
              keyboardType: TextInputType.text,
              icon: Icons.account_circle,
              controller: controller.usernameController,
              onChanged: (value) => controller.usernameController.text = value,
            ),
            SizedBox(height: 32.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => controller.saveUser(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.principalButton,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: Text('Guardar'),
                ),
                ElevatedButton(
                  onPressed: () => controller.clearFields(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.invalid,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
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