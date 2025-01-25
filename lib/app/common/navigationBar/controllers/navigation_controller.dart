import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:teck_app/app/routes/app_routes.dart';

class BottomNavigationController extends GetxController {
  var currentIndex = 0.obs;

  void navigateTo(int index) {
    currentIndex.value = index;

    switch (index) {
      case 0:
        Get.offNamed(AppRoutes.HOME);
        break;
      case 1:
        Get.offNamed(AppRoutes.PRODUCTS);
        break;
      case 2:
        Get.offNamed(AppRoutes.SELLS);
        break;
      case 3:
        Get.offNamed(AppRoutes.MENUALL);
        break;
      default:
        break;
    }
  }
}