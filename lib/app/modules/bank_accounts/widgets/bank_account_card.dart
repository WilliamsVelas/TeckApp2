import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../theme/colors.dart';
import '../../../database/models/bank_account_model.dart';
import '../controller/bank_account_controller.dart';

class BankAccountCard extends StatelessWidget {
  final BankAccount bankAccount;

  const BankAccountCard({Key? key, required this.bankAccount}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final BankAccountController controller = Get.find<BankAccountController>();
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
                      '${bankAccount.code}-${bankAccount.numberAccount}',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.principalGray,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          bankAccount.bankName,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.principalGray,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          bankAccount.isActive ? 'Activo' : 'Inactivo', // Mostrar estado
                          style: TextStyle(
                            fontSize: 12,
                            color: bankAccount.isActive ? Colors.green : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 4),
                // Client Name
                FutureBuilder<String>(
                  future: controller.getClientName(bankAccount.clientId),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text(
                        snapshot.data!,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.principalWhite,
                        ),
                      );
                    } else {
                      return Text(
                        'Cargando...',
                        style: TextStyle(color: AppColors.principalGray),
                      );
                    }
                  },
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
                          onPressed: bankAccount.isActive
                              ? () {
                            controller.deactivateBankAccount(bankAccount.id!);
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
