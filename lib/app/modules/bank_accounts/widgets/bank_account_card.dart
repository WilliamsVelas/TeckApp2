import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../theme/colors.dart';
import '../../../database/models/bank_account_model.dart';
import '../controller/bank_account_controller.dart';

class BankAccountCard extends StatelessWidget {
  final BankAccount bankAccount;

  const BankAccountCard({Key? key, required this.bankAccount})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final BankAccountController controller = Get.find<BankAccountController>();
    RxBool isExpanded = false.obs;

    return Obx(
      () => GestureDetector(
        onTap: () => isExpanded.value = !isExpanded.value,
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
                    FutureBuilder<String>(
                      future: controller.getClientName(bankAccount.clientId),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Text(
                            snapshot.data!,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.principalGray,
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
                    Text(
                      bankAccount.isActive ? 'Activo' : 'Inactivo',
                      style: TextStyle(
                        fontSize: 12,
                        color: bankAccount.isActive ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${bankAccount.code}-${bankAccount.numberAccount}',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.principalWhite,
                      ),
                    ),
                    Text(
                      bankAccount.bankName,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.principalGray,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                if (isExpanded.value)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: AppColors.warning,
                          ),
                          onPressed: bankAccount.isActive
                              ? () {
                                  controller.editBankAccount(
                                      bankAccount, context);
                                  isExpanded.value = false;
                                }
                              : null,
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.clear,
                            color: AppColors.invalid,
                          ),
                          onPressed: bankAccount.isActive
                              ? () {
                                  controller
                                      .deactivateBankAccount(bankAccount.id!);
                                  isExpanded.value = false;
                                }
                              : null,
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
