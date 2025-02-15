import 'package:get/get.dart';
import 'package:teck_app/app/modules/providers/controllers/provider_controller.dart';

class ProviderBinding extends Bindings{
  @override
  void dependencies(){
    Get.lazyPut<ProviderController>(() => ProviderController());
  }
}