import 'package:get/get.dart';
import 'package:teck_app/app/modules/invoices/controllers/invoice_controller.dart';

import '../../../common/navigationBar/controllers/navigation_controller.dart';

class InvoiceBinding extends Bindings{
  @override
  void dependencies(){
    Get.lazyPut<InvoiceController>(()=> InvoiceController());
    Get.lazyPut<BottomNavigationController>(() => BottomNavigationController());
  }
}