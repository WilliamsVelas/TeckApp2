import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:teck_app/app/modules/all_options/bindings/all_options_binding.dart';
import 'package:teck_app/app/modules/all_options/views/all_options_view.dart';
import 'package:teck_app/app/modules/bank_accounts/bindings/bank_account_binding.dart';
import 'package:teck_app/app/modules/bank_accounts/views/bank_account_view.dart';
import 'package:teck_app/app/modules/categories/bindings/categories_binding.dart';
import 'package:teck_app/app/modules/categories/views/categories_view.dart';
import 'package:teck_app/app/modules/clients/bindings/client_binding.dart';
import 'package:teck_app/app/modules/clients/views/clients_view.dart';
import 'package:teck_app/app/modules/home/bindings/home_binding.dart';
import 'package:teck_app/app/modules/home/views/home_view.dart';
import 'package:teck_app/app/modules/payment_method/bindings/payment_method_binding.dart';
import 'package:teck_app/app/modules/payment_method/views/payment_method_view.dart';
import 'package:teck_app/app/modules/products/bindings/product_binding.dart';
import 'package:teck_app/app/modules/products/views/product_view.dart';
import 'package:teck_app/app/modules/providers/bindings/provider_binding.dart';
import 'package:teck_app/app/modules/providers/views/provier_view.dart';
import 'package:teck_app/app/modules/user/bindings/user_binding.dart';
import 'package:teck_app/app/modules/user/views/user_view.dart';
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
    //Categories view
    GetPage(
      name: AppRoutes.PAYMENTMETHOD,
      page: () => PaymentMethodView(),
      binding: PaymentMethodBinding(),
    ),
    //Clients view
    GetPage(
      name: AppRoutes.CLIENTS,
      page: () => ClientView(),
      binding: ClientBinding(),
    ),
    //Providers view
    GetPage(
      name: AppRoutes.PROVIDERS,
      page: () => ProviderView(),
      binding: ProviderBinding(),
    ),
    //Bank accounts view
    GetPage(
      name: AppRoutes.BANK_ACCOUNT,
      page: () => BankAccountView(),
      binding: BankAccountBinding(),
    ),
    //User view
    GetPage(
      name: AppRoutes.USER,
      page: () => UserView(),
      binding: UserBinding(),
    ),
  ];
}
