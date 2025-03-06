import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:teck_app/app/modules/all_options/controllers/all_options_controller.dart';

import '../../../../theme/colors.dart';
import '../../../routes/app_routes.dart';
import '../widgets/card_buttom.dart';

class AllOptionsView extends StatelessWidget {
  final AllOptionsController allOptionsController =
      Get.find<AllOptionsController>();

  final List<Map<String, dynamic>> options = [
    {
      'icon': Icons.category,
      'name': 'Categorias',
      'route': AppRoutes.CATEGORIES,
      'color': AppColors.principalGreen,
      'iconColor': AppColors.onPrincipalBackground,
    },
    {
      'icon': Icons.payments_outlined,
      'name': 'Metodos de pago',
      'route': AppRoutes.PAYMENTMETHOD,
      'color': AppColors.principalGreen,
      'iconColor': AppColors.onPrincipalBackground,
    },
    {
      'icon': Icons.group,
      'name': 'Clientes',
      'route': AppRoutes.CLIENTS,
      'color': AppColors.principalGreen,
      'iconColor': AppColors.onPrincipalBackground,
    },
    {
      'icon': Icons.comment_bank,
      'name': 'C. Bancos',
      'route': AppRoutes.BANK_ACCOUNT,
      'color': AppColors.principalGreen,
      'iconColor': AppColors.onPrincipalBackground,
    },
    {
      'icon': Icons.receipt,
      'name': 'Cuentas',
      'route': AppRoutes.PAYMENTMETHOD,
      'color': AppColors.principalGreen,
      'iconColor': AppColors.onPrincipalBackground,
    },
    {
      'icon': Icons.person_pin_circle_outlined,
      'name': 'Proveedores',
      'route': AppRoutes.PROVIDERS,
      'color': AppColors.principalGreen,
      'iconColor': AppColors.onPrincipalBackground,
    },
    {
      'icon': Icons.stacked_bar_chart,
      'name': 'Estadisticas',
      'route': AppRoutes.STATISTICS,
      'color': AppColors.principalGreen,
      'iconColor': AppColors.onPrincipalBackground,
    },
    {
      'icon': Icons.inventory_outlined,
      'name': 'Reportes',
      'route': AppRoutes.PROVIDERS,
      'color': AppColors.principalGreen,
      'iconColor': AppColors.onPrincipalBackground,
    },
    {
      'icon': Icons.account_circle,
      'name': 'Perfil',
      'route': AppRoutes.USER,
      'color': AppColors.principalGreen,
      'iconColor': AppColors.onPrincipalBackground,
    },
    // {
    //   'icon': Icons.settings,
    //   'name': 'Configuracion',
    //   'route': AppRoutes.PROVIDERS,
    //   'color': Colors.blue,
    //   'iconColor': AppColors.onPrincipalBackground,
    // },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.onPrincipalBackground,
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_left_outlined,
              color: AppColors.principalWhite),
          onPressed: () => Get.offAllNamed(AppRoutes.HOME),
        ),
        title: const Text(''),
      ),
      body: Container(
        color: AppColors.onPrincipalBackground,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1,
            ),
            itemCount: options.length,
            itemBuilder: (context, index) {
              final option = options[index];
              return CardButton(
                onPress: () => Get.toNamed(option['route']),
                icon: option['icon'],
                name: option['name'],
                color: option['color'],
                iconColor: option['iconColor'],
              );
            },
          ),
        ),
      ),
    );
  }
}
