import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:teck_app/app/common/navigationBar/controllers/navigation_controller.dart';
import 'package:teck_app/app/modules/home/controllers/home_controller.dart';
import 'package:teck_app/app/modules/products/controllers/product_controller.dart';

class HomeBinding extends Bindings{
  @override
  void dependencies(){
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<ProductController>(() => ProductController());
  }
}