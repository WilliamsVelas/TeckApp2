import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:teck_app/app/modules/dashboard/views/dashboard_view.dart';
import 'package:teck_app/app/modules/invoices/views/invoice_view.dart';
import 'package:teck_app/app/modules/products/views/product_view.dart';
import 'package:teck_app/app/routes/app_routes.dart';

import '../../../database/database_helper.dart';
import '../../../database/models/user_model.dart';

class HomeController extends GetxController {
  final RxInt _currentIndex = 0.obs;
  final List<Widget> pages = [
    _NavigatorWrapper(child: DashboardView()),
    _NavigatorWrapper(child: ProductView()),
    _NavigatorWrapper(child: InvoiceView()),
  ];

  final dbHelper = DatabaseHelper();

  final RxString username = 'Usuario'.obs;

  int get currentIndex => _currentIndex.value;

  Widget get currentPage => pages[_currentIndex.value];

  @override
  void onInit() {
    super.onInit();
    fetchUser();
  }


  void changeTab(int index) {
    if (index == 3) {
      Get.toNamed(AppRoutes.MENUALL);
    } else {
      _currentIndex.value = index;
    }
  }

  bool get showAppBar => currentIndex == 0;

  bool get showBottomNav => currentIndex != 3;

  Future<void> fetchUser() async {
    final List<UserApp> users = await dbHelper.getUsers();
    if (users.isNotEmpty) {
      username.value = users.first.username;
    }else{
      Get.toNamed(AppRoutes.USER);
    }
  }
}

class _NavigatorWrapper extends StatelessWidget {
  final Widget child;

  const _NavigatorWrapper({required this.child});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: Get.nestedKey(child.hashCode),
      onGenerateRoute: (settings) => MaterialPageRoute(
        builder: (context) => child,
        settings: settings,
      ),
    );
  }
}
