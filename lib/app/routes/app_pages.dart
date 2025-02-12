import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:teck_app/app/modules/all_options/bindings/all_options_binding.dart';
import 'package:teck_app/app/modules/all_options/views/all_options_view.dart';
import 'package:teck_app/app/modules/categories/bindings/categories_binding.dart';
import 'package:teck_app/app/modules/categories/views/categories_view.dart';
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
    //Menu all view
    GetPage(
      name: AppRoutes.MENUALL,
      page: () => AllOptionsView(),
      binding: AllOptionsBinding(),
    ),
    //Categories view
    GetPage(
      name: AppRoutes.CATEGORIES,
      page: () => CategoriesView(),
      binding: CategoriesBinding(),
    ),
  ];
}
