import 'package:get/get.dart';
import 'package:teck_app/app/common/navigationBar/controllers/navigation_controller.dart';
import 'package:teck_app/app/modules/products/controllers/product_controller.dart';

class ProductBinding extends Bindings{
  @override
  void dependencies(){
    Get.lazyPut<ProductController>(() => ProductController());
    Get.lazyPut<BottomNavigationController>(() => BottomNavigationController());
  }
}