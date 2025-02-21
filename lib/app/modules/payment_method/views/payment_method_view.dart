import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:teck_app/app/modules/payment_method/controllers/payment_method_controller.dart';

import '../../../../theme/colors.dart';
import '../../../common/generic_input.dart';
import '../widgets/payment_method_card.dart';
import '../widgets/payment_method_form.dart';

class PaymentMethodView extends GetView<PaymentMethodController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.onPrincipalBackground,
        leading: IconButton(
          icon: Icon(
            Icons.keyboard_arrow_left_outlined,
            color: AppColors.principalWhite,
          ),
          onPressed: () => Get.back(),
        ),
        title: const Text(''),
      ),
      backgroundColor: AppColors.onPrincipalBackground,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: GenericInput(
                    hintText: 'Buscar metodos de pago...',
                    onChanged: (value) {
                      controller.searchPaymentMethods(value);
                    },
                    prefixIcon: const Icon(Icons.search),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.sort),
                  onPressed: () {
                    _showSortDialog(context, controller);
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: const BoxDecoration(
                color: AppColors.principalBackground,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(32.0),
                  bottom: Radius.circular(32.0),
                ),
              ),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Métodos de Pago',
                    style: TextStyle(fontSize: 18.0, color: AppColors.principalWhite, fontWeight: FontWeight.bold),
                  ),
                  Obx(() =>
                      Text(
                        '${controller.paymentMethods.length} métodos de pago',
                        style: TextStyle(fontSize: 12.0, color: AppColors.principalGray),
                      ),
                  ),
                  Expanded(
                    child: Obx(() {
                      final paymentMethods = controller.paymentMethods;
                      if (paymentMethods.isEmpty) {
                        return const Center(
                          child: Text(
                            'No hay métodos de pago disponibles.',
                            style: TextStyle(fontSize: 16.0, color: Colors.black),
                          ),
                        );
                      }
                      return ListView.builder(
                        itemCount: paymentMethods.length,
                        itemBuilder: (context, index) {
                          final paymentMethod = paymentMethods[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: PaymentMethodCard(paymentMethod: paymentMethod),
                          );
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: ElevatedButton(
              onPressed: () {
                _openPaymentMethodForm(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.principalButton,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32.0),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                child: Text(
                  'Agregar',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: AppColors.onPrincipalBackground,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16.0),
        ],
      ),
    );
  }

  void _showSortDialog(BuildContext context, PaymentMethodController controller) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Ordenar metodos de pago'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Fecha de creación'),
                onTap: () {
                  controller.sortPaymentMethods("date");
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Nombre'),
                onTap: () {
                  controller.sortPaymentMethods("name");
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _openPaymentMethodForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.onPrincipalBackground,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            top: 16.0,
            left: 16.0,
            right: 16.0,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: PaymentMethodForm(),
        );
      },
    );
  }
}