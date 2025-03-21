import 'package:get/get.dart';
import 'package:teck_app/app/modules/clients/controllers/clients_controller.dart';

import '../../bank_accounts/controller/bank_account_controller.dart';

class ClientBinding extends Bindings{
  @override
  void dependencies(){
    Get.lazyPut<ClientsController>(() => ClientsController());
    Get.lazyPut<BankAccountController>(() => BankAccountController());
  }
}