import 'package:get/get.dart';
import 'package:teck_app/app/modules/dashboard/controllers/dashboard_controller.dart';

import '../../../common/navigationBar/controllers/navigation_controller.dart';

class DashboardBinding extends Bindings{
  @override
  void dependencies(){
    Get.lazyPut<DashboardController>(() => DashboardController());
    Get.lazyPut<BottomNavigationController>(() => BottomNavigationController());
  }
}