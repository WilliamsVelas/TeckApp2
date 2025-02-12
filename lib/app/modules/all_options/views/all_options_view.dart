import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:teck_app/app/modules/all_options/controllers/all_options_controller.dart';

import '../../../routes/app_routes.dart';
import '../widgets/card_buttom.dart';

class AllOptionsView extends StatelessWidget {
  final AllOptionsController allOptionsController =
      Get.find<AllOptionsController>();

  final List<Map<String, dynamic>> options = [
    // {
    //   'icon': Icons.settings,
    //   'name': 'Configuración',
    //   'route': AppRoutes.SETTINGS,
    //   'color': Colors.blue,
    //   'iconColor': Colors.white,
    // },
    // {
    //   'icon': Icons.person,
    //   'name': 'Perfil',
    //   'route': AppRoutes.PROFILE,
    //   'color': Colors.green,
    //   'iconColor': Colors.white,
    // },
    // {
    //   'icon': Icons.shopping_cart,
    //   'name': 'Compras',
    //   'route': AppRoutes.SHOP,
    //   'color': Colors.orange,
    //   'iconColor': Colors.white,
    // },
    // {
    //   'icon': Icons.notifications,
    //   'name': 'Notificaciones',
    //   'route': AppRoutes.NOTIFICATIONS,
    //   'color': Colors.red,
    //   'iconColor': Colors.white,
    // },
    // {
    //   'icon': Icons.help,
    //   'name': 'Ayuda',
    //   'route': AppRoutes.HELP,
    //   'color': Colors.purple,
    //   'iconColor': Colors.white,
    // },
    // {
    //   'icon': Icons.info,
    //   'name': 'Información',
    //   'route': AppRoutes.INFO,
    //   'color': Colors.teal,
    //   'iconColor': Colors.white,
    // },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Más Opciones')),
      body: Padding(
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
    );
  }
}
