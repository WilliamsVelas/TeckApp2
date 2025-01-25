import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:teck_app/app/common/navigationBar/controllers/navigation_controller.dart';
import 'package:teck_app/theme/colors.dart';

class CustomBottomNavigationBarw extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bottomNavController = Get.find<BottomNavigationController>();

    return Obx(() => BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.onPrincipalBackground,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey[400],
          currentIndex: bottomNavController.currentIndex.value,
          onTap: bottomNavController.navigateTo,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Inicio",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.inventory),
              label: "Productos",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.sell),
              label: "Ventas",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.more_vert_sharp),
              label: "Más",
            ),
          ],
        ));
  }
}
