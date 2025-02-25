import 'package:get/get.dart';
import 'package:teck_app/app/modules/bank_accounts/controller/bank_account_controller.dart';

class BankAccountBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BankAccountController>(() => BankAccountController());
  }
}
