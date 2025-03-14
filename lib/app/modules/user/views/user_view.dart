import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:teck_app/app/modules/user/controllers/user_controller.dart';
import 'package:teck_app/app/modules/user/widgets/user_form.dart';

import '../../../../theme/colors.dart';

class UserView extends GetView<UserController> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    String formatDateTime(DateTime dateTime) {
      return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.onPrincipalBackground,
        leading: IconButton(
          icon: Icon(
            Icons.keyboard_arrow_left_outlined,
            color: AppColors.principalWhite,
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Usuario',
          style: TextStyle(color: AppColors.principalWhite),
        ),
      ),
      backgroundColor: AppColors.onPrincipalBackground,
      body: Obx(
            () => controller.isLoading.value
            ? Center(
          child: CircularProgressIndicator(
            color: AppColors.principalWhite,
          ),
        )
            : controller.user.value == null
            ? UseFormView()
            : Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Detalles del usuario',
                style: textTheme.displaySmall?.copyWith(
                  color: AppColors.principalWhite,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 24),
              InfoRow(
                title: 'Nombre: ',
                text: controller.user.value!.name,
              ),
              SizedBox(height: 16),
              InfoRow(
                title: 'Apellido: ',
                text: controller.user.value!.lastName,
              ),
              SizedBox(height: 16),
              InfoRow(
                title: 'Usuario: ',
                text: controller.user.value!.username,
              ),
              SizedBox(height: 16),
              InfoRow(
                title: 'Creado: ',
                text: '${DateFormat('dd/MM/yyyy').format(DateTime.fromMillisecondsSinceEpoch(controller.user.value!.createdAt))}',
              ),
              SizedBox(height: 16),
              if (controller.user.value!.updatedAt != null) ...[
                InfoRow(
                  title: 'Actualizado: ',
                  text: '${DateFormat('dd/MM/yyyy').format(DateTime.fromMillisecondsSinceEpoch(controller.user.value!.updatedAt!))}',
                ),
                SizedBox(height: 16),
              ],
              InfoRow(
                title: 'Estado: ',
                text: controller.user.value!.isActive
                    ? 'Activo'
                    : 'Inactivo',
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: ElevatedButton(
                  onPressed: () => controller.logout(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.invalid,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 12.0),
                    child: Text(
                      'Cerrar sesión',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: AppColors.onPrincipalBackground,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UseFormView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // controller.clearFields();
        return true;
      },
      child: Scaffold(
        backgroundColor: AppColors.onPrincipalBackground,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: UserForm(),
        ),
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final String title;
  final String text;

  const InfoRow({
    Key? key,
    required this.title,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.bodySmall?.copyWith(
            fontSize: 16,
            color: AppColors.principalWhite,
          ),
        ),
        Text(
          text,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontSize: 16,
            color: AppColors.principalWhite,
          ),
        ),
      ],
    );
  }
}
