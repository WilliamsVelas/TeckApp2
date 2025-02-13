import 'package:get/get.dart';
import 'package:teck_app/app/modules/payment_method/controllers/payment_method_controller.dart';

class PaymentMethodBinding extends Bindings{
  @override
  void dependencies(){
    Get.lazyPut<PaymentMethodController>(() => PaymentMethodController());
  }
}