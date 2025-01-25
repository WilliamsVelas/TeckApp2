import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:teck_app/app/modules/home/bindings/home_binding.dart';
import 'package:teck_app/app/modules/home/views/home_view.dart';
import 'package:teck_app/app/modules/products/bindings/product_binding.dart';
import 'package:teck_app/app/modules/products/views/product_view.dart';
import 'package:teck_app/app/routes/app_routes.dart';

class AppPages {
  static const initial = AppRoutes.HOME;

  static final routes = [
    //Home view
    GetPage(
      name: AppRoutes.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),

    //Product view
    // GetPage(
    //   name: AppRoutes.PRODUCTS,
    //   page: () => ProductViews(),
    //   binding: ProductBinding(),
    // ),
  ];
}
