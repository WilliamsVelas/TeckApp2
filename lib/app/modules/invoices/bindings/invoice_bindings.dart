import 'package:get/get.dart';
import 'package:teck_app/app/modules/invoices/controllers/invoice_controller.dart';

class InvoiceBinding extends Bindings{
  @override
  void dependencies(){
    Get.lazyPut<InvoiceController>(()=> InvoiceController());
  }
}