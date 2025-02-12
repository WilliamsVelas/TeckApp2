import 'package:get/get.dart';
import 'package:teck_app/app/modules/all_options/controllers/all_options_controller.dart';

class AllOptionsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AllOptionsController>(() => AllOptionsController());
  }
}
