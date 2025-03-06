import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:teck_app/app/modules/products/views/product_view.dart';
import 'package:teck_app/theme/colors.dart';

import '../../all_options/views/all_options_view.dart';
import '../../invoices/views/invoice_view.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.onPrincipalBackground,
      body: Obx(
        () => Column(
          children: [
            if (controller.showAppBar) CustomAppBar(userName: controller.username.value),
            Expanded(
              child: controller.currentPage,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Obx(() => controller.showBottomNav
          ? CustomBottomNavigationBar(
              currentIndex: controller.currentIndex,
              onTabSelected: controller.changeTab,
            )
          : const SizedBox.shrink()),
    );
  }
}

class CustomAppBar extends StatelessWidget {
  final String userName;

  const CustomAppBar({Key? key, required this.userName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Container(
      padding: EdgeInsets.only(
        top: statusBarHeight,
        left: 16.0,
        right: 16.0,
      ),
      height: MediaQuery.of(context).size.height * 0.1 + statusBarHeight,
      color: AppColors.onPrincipalBackground,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Bienvenido,",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                userName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const CircleAvatar(
            radius: 20.0,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.person,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabSelected;

  const CustomBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onTabSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.onPrincipalBackground,
          selectedItemColor: AppColors.principalGreen,
          unselectedItemColor: AppColors.menuSideBar,
          currentIndex: currentIndex,
          onTap: onTabSelected,
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
        ),
      ),
    );
  }
}

class GenericScreen extends StatelessWidget {
  final ScreenConfig config;

  const GenericScreen({Key? key, required this.config}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: config.backgroundColor,
      body: Column(
        children: [
          if (config.title.isNotEmpty ||
              config.searchBar != null ||
              config.actions.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: config.searchBar ?? const SizedBox.shrink(),
                  ),
                  ...config.actions,
                ],
              ),
            ),
          Expanded(
            child: config.content,
          ),
          if (config.bottomButton != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: config.bottomButton,
            ),
        ],
      ),
    );
  }
}

class ScreenConfig {
  final String title;
  final Widget? searchBar;
  final List<Widget> actions;
  final Widget content;
  final Widget? bottomButton;
  final Color? backgroundColor;

  ScreenConfig({
    required this.content,
    this.title = '',
    this.searchBar,
    this.actions = const [],
    this.bottomButton,
    this.backgroundColor,
  });
}
