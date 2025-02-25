import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../theme/colors.dart';
import '../../../database/models/payment_method_model.dart';
import '../controllers/payment_method_controller.dart';

class PaymentMethodCard extends StatelessWidget {
  final PaymentMethod paymentMethod;

  const PaymentMethodCard({Key? key, required this.paymentMethod}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PaymentMethodController controller = Get.find<PaymentMethodController>();
    RxBool isExpanded = false.obs; // Estado para controlar expansión

    return Obx(
          () => GestureDetector(
        onTap: () => isExpanded.value = !isExpanded.value, // Alternar expansión
        child: Card(
          color: AppColors.onPrincipalBackground,
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '#${paymentMethod.code}',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.principalGray,
                      ),
                    ),
                    Text(
                      paymentMethod.isActive ? 'Activo' : 'Inactivo', // Mostrar estado
                      style: TextStyle(
                        fontSize: 12,
                        color: paymentMethod.isActive ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  paymentMethod.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.principalWhite,
                  ),
                ),
                if (isExpanded.value) // Mostrar íconos cuando está expandido
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: paymentMethod.isActive
                              ? () {
                            controller.deactivatePaymentMethod(paymentMethod.id!);
                            isExpanded.value = false; // Contraer al desactivar
                          }
                              : null, // Deshabilitar si ya está inactivo
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}